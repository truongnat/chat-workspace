use axum::{
    extract::{ws::{Message, WebSocket, WebSocketUpgrade}, State, Query},
    response::IntoResponse,
};
use futures::{sink::SinkExt, stream::StreamExt};
use serde::Deserialize;
use std::sync::Arc;
use tokio::sync::broadcast;
use uuid::Uuid;

use crate::api::handlers::AppState;
use crate::application::{WebSocketMessage, SendMessageRequest};

#[derive(Deserialize)]
pub struct WsParams {
    token: String,
    // In a real app, we verify the token here or in middleware
    // For now, we'll accept a user_id for testing if token is mock
    user_id: Option<String>, 
}

pub async fn ws_handler(
    ws: WebSocketUpgrade,
    State(state): State<Arc<AppState>>,
    Query(params): Query<WsParams>,
) -> impl IntoResponse {
    // TODO: Verify JWT token here
    let user_id = params.user_id.unwrap_or_else(|| Uuid::new_v4().to_string());
    
    ws.on_upgrade(move |socket| handle_socket(socket, state, user_id))
}

async fn handle_socket(socket: WebSocket, state: Arc<AppState>, user_id: String) {
    let (mut sender, mut receiver) = socket.split();
    let mut rx = state.tx.subscribe();

    // Spawn a task to forward broadcast messages to this client
    let mut send_task = tokio::spawn(async move {
        while let Ok(msg) = rx.recv().await {
            // In a real app, filter messages for this user/conversation
            if sender.send(Message::Text(msg)).await.is_err() {
                break;
            }
        }
    });

    // Handle incoming messages from this client
    let mut recv_task = tokio::spawn(async move {
        while let Some(Ok(msg)) = receiver.next().await {
            if let Message::Text(text) = msg {
                // Parse message
                if let Ok(ws_msg) = serde_json::from_str::<WebSocketMessage>(&text) {
                    match ws_msg.event.as_str() {
                        "SendMessage" => {
                            if let Ok(req) = serde_json::from_value::<SendMessageRequest>(ws_msg.data) {
                                // Persist message
                                if let Ok(saved_msg) = state.send_message.execute(
                                    Uuid::parse_str(&user_id).unwrap_or_default(),
                                    req.conversation_id,
                                    req.content,
                                    req.message_type,
                                    req.reply_to_id,
                                    req.self_destruct_in_seconds
                                ).await {
                                    // Broadcast to others via Redis/Internal Channel
                                    // For now, using internal broadcast channel
                                    let _ = state.tx.send(serde_json::to_string(&saved_msg).unwrap_or_default());
                                }
                            }
                        },
                        "SystemEvent" => {
                            // Handle anti-screenshot, etc.
                            let _ = state.tx.send(text);
                        },
                        _ => {}
                    }
                }
            }
        }
    });

    // If any one of the tasks exit, abort the other
    tokio::select! {
        _ = (&mut send_task) => recv_task.abort(),
        _ = (&mut recv_task) => send_task.abort(),
    };
}
