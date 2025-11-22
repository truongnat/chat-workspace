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
