use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct User {
    pub id: Uuid,
    pub phone_number: String,
    pub password_hash: String,
    pub name: Option<String>,
    pub username: Option<String>,
    pub bio: Option<String>,
    pub avatar_url: Option<String>,
    pub location: Option<(f64, f64)>, // (latitude, longitude)
    pub is_verified: bool,
    pub is_online: bool,
    pub last_seen: Option<DateTime<Utc>>,
    pub subscription_tier: SubscriptionTier,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum SubscriptionTier {
    Free,
    Monthly,
    Yearly,
}

impl User {
    pub fn new(phone_number: String, password_hash: String) -> Self {
        let now = Utc::now();
        Self {
            id: Uuid::new_v4(),
            phone_number,
            password_hash,
            name: None,
            username: None,
            bio: None,
            avatar_url: None,
            location: None,
            is_verified: false,
            is_online: false,
            last_seen: None,
            subscription_tier: SubscriptionTier::Free,
            created_at: now,
            updated_at: now,
        }
    }

    pub fn is_premium(&self) -> bool {
        matches!(
            self.subscription_tier,
            SubscriptionTier::Monthly | SubscriptionTier::Yearly
        )
    }
}
