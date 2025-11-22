use async_trait::async_trait;
use crate::domain::{services::NotificationService, DomainResult};

pub struct FcmService;

impl FcmService {
    pub fn new() -> Self {
        Self
    }
}

#[async_trait]
impl NotificationService for FcmService {
    async fn send_notification(&self, user_id: &str, title: &str, body: &str, data: Option<serde_json::Value>) -> DomainResult<()> {
        // TODO: Integrate with real FCM using `fcm` crate or HTTP API
        // For now, we log the notification to simulate sending
        tracing::info!(
            "🚀 [FCM Mock] Sending to User {}: Title='{}', Body='{}', Data={:?}",
            user_id, title, body, data
        );
        
        Ok(())
    }
}
