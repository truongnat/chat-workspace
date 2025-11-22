use std::sync::Arc;
use std::time::Duration;
use tokio::time;

use crate::domain::repositories::MessageRepository;

pub struct MessageCleanupJob {
    message_repo: Arc<dyn MessageRepository>,
}

impl MessageCleanupJob {
    pub fn new(message_repo: Arc<dyn MessageRepository>) -> Self {
        Self { message_repo }
    }

    pub async fn run(&self) {
        let mut interval = time::interval(Duration::from_secs(60)); // Run every minute

        loop {
            interval.tick().await;
            
            match self.message_repo.delete_expired().await {
                Ok(count) => {
                    if count > 0 {
                        tracing::info!("Cleaned up {} expired messages", count);
                    }
                }
                Err(e) => {
                    tracing::error!("Failed to cleanup expired messages: {}", e);
                }
            }
        }
    }
}
