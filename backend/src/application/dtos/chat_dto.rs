use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct SendMessageRequest {
    pub conversation_id: Uuid,
    
    #[validate(length(min = 1))]
    pub content: String,
    
    pub message_type: String,
    pub reply_to_id: Option<Uuid>,
    pub self_destruct_in_seconds: Option<i64>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct MessageResponse {
    pub id: Uuid,
    pub conversation_id: Uuid,
    pub sender_id: Uuid,
    pub content: String,
    pub message_type: String,
    pub created_at: DateTime<Utc>,
    pub self_destruct_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct WebSocketMessage {
    pub event: String,
    pub data: serde_json::Value,
}
