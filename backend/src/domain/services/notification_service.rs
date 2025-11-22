use async_trait::async_trait;
use crate::domain::DomainResult;

#[async_trait]
pub trait NotificationService: Send + Sync {
    async fn send_notification(&self, user_id: &str, title: &str, body: &str, data: Option<serde_json::Value>) -> DomainResult<()>;
}
