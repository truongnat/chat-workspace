use serde::{Deserialize, Serialize};
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct UpgradeSubscriptionRequest {
    #[validate(length(min = 1))]
    pub tier: String, // "Free", "Premium", "Gold"
    
    pub payment_token: Option<String>, // Mock payment token
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SubscriptionResponse {
    pub tier: String,
    pub expires_at: Option<String>,
    pub features: Vec<String>,
}
