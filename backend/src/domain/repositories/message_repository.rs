use async_trait::async_trait;
use uuid::Uuid;

use crate::domain::{entities::Message, DomainResult};

#[async_trait]
pub trait MessageRepository: Send + Sync {
    async fn create(&self, message: &Message) -> DomainResult<Message>;
    async fn find_by_id(&self, id: Uuid) -> DomainResult<Option<Message>>;
    async fn find_by_conversation(
        &self,
        conversation_id: Uuid,
        limit: i64,
        offset: i64,
    ) -> DomainResult<Vec<Message>>;
    async fn update(&self, message: &Message) -> DomainResult<Message>;
    async fn delete(&self, id: Uuid) -> DomainResult<()>;
    async fn delete_expired(&self) -> DomainResult<u64>;
    async fn mark_as_read(&self, message_id: Uuid, user_id: Uuid) -> DomainResult<()>;
    async fn add_reaction(&self, message_id: Uuid, user_id: Uuid, reaction: &str) -> DomainResult<()>;
}
