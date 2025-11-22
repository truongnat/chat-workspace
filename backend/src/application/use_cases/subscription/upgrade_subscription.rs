use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    repositories::UserRepository,
    DomainResult,
};
use crate::application::SubscriptionResponse;

pub struct UpgradeSubscription {
    user_repo: Arc<dyn UserRepository>,
}

impl UpgradeSubscription {
    pub fn new(user_repo: Arc<dyn UserRepository>) -> Self {
        Self { user_repo }
    }

    pub async fn execute(&self, user_id: Uuid, tier: String) -> DomainResult<SubscriptionResponse> {
        // In a real app, we would verify payment_token here
        
        let updated_user = self.user_repo.update_subscription(user_id, tier.clone()).await?;

        // Define features based on tier
        let features = match tier.as_str() {
            "Premium" => vec![
                "Unlimited Messages".to_string(), 
                "4K Video Calls".to_string(),
                "Verified Badge".to_string()
            ],
            "Gold" => vec![
                "Unlimited Messages".to_string(), 
                "8K Video Calls".to_string(),
                "Verified Badge".to_string(),
                "Priority Support".to_string()
            ],
            _ => vec!["Standard Messaging".to_string()],
        };

        Ok(SubscriptionResponse {
            tier: updated_user.subscription_tier.unwrap_or_else(|| "Free".to_string()),
            expires_at: None, // Lifetime for this MVP
            features,
        })
    }
}
