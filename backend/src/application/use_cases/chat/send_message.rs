use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    entities::{Message, MessageType},
    repositories::MessageRepository,
    DomainError, DomainResult,
};

pub struct SendMessage {
    message_repo: Arc<dyn MessageRepository>,
}

impl SendMessage {
    pub fn new(message_repo: Arc<dyn MessageRepository>) -> Self {
        Self { message_repo }
    }

    pub async fn execute(
        &self,
        sender_id: Uuid,
        conversation_id: Uuid,
        content: String,
        message_type_str: String,
        reply_to_id: Option<Uuid>,
        self_destruct_in_seconds: Option<i64>,
    ) -> DomainResult<Message> {
        let message_type = match message_type_str.as_str() {
            "Image" => MessageType::Image,
            "Video" => MessageType::Video,
            "Audio" => MessageType::Audio,
            "File" => MessageType::File,
            "System" => MessageType::System,
            "CallSignal" => MessageType::CallSignal,
            _ => MessageType::Text,
        };

        let mut message = Message::new(conversation_id, sender_id, content, message_type);
        message.reply_to_id = reply_to_id;

        if let Some(seconds) = self_destruct_in_seconds {
            message = message.with_self_destruct(seconds);
        }

        self.message_repo.create(&message).await
    }
}
