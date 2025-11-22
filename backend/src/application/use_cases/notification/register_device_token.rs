use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    repositories::UserRepository,
    DomainResult,
};

pub struct RegisterDeviceToken {
    user_repo: Arc<dyn UserRepository>,
}

impl RegisterDeviceToken {
    pub fn new(user_repo: Arc<dyn UserRepository>) -> Self {
        Self { user_repo }
    }

    pub async fn execute(&self, user_id: Uuid, token: String) -> DomainResult<()> {
        // In a real app, we would save this token to a `device_tokens` table
        // For now, we'll just log it or assume the repo handles it (mocked)
        tracing::info!("Registering device token for user {}: {}", user_id, token);
        
        // self.user_repo.add_device_token(user_id, token).await?;
        
        Ok(())
    }
}
