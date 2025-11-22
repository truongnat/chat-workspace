use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct Message {
    pub id: Uuid,
    pub conversation_id: Uuid,
    pub sender_id: Option<Uuid>,
    pub content: String,
    pub message_type: MessageType,
    pub is_encrypted: bool,
    pub reply_to_id: Option<Uuid>,
    pub self_destruct_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    pub is_deleted: bool,
}

#[derive(Debug, Clone, PartialEq)]
pub enum MessageType {
    Text,
    Image,
    Video,
    Audio,
    File,
    System,
    CallSignal,
}

impl Message {
    pub fn new(
        conversation_id: Uuid,
        sender_id: Uuid,
        content: String,
        message_type: MessageType,
    ) -> Self {
        Self {
            id: Uuid::new_v4(),
            conversation_id,
            sender_id: Some(sender_id),
            content,
            message_type,
            is_encrypted: true,
            reply_to_id: None,
            self_destruct_at: None,
            created_at: Utc::now(),
            is_deleted: false,
        }
    }

    pub fn with_self_destruct(mut self, duration_seconds: i64) -> Self {
        self.self_destruct_at = Some(Utc::now() + chrono::Duration::seconds(duration_seconds));
        self
    }

    pub fn is_expired(&self) -> bool {
        if let Some(destruct_at) = self.self_destruct_at {
            Utc::now() > destruct_at
        } else {
            false
        }
    }
}
