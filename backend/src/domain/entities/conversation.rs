use chrono::{DateTime, Utc};
use serde_json::Value as JsonValue;
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct Conversation {
    pub id: Uuid,
    pub conversation_type: ConversationType,
    pub name: Option<String>,
    pub avatar_url: Option<String>,
    pub settings: JsonValue,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum ConversationType {
    Private,
    Group,
}

impl Conversation {
    pub fn new_private() -> Self {
        let now = Utc::now();
        Self {
            id: Uuid::new_v4(),
            conversation_type: ConversationType::Private,
            name: None,
            avatar_url: None,
            settings: serde_json::json!({}),
            created_at: now,
            updated_at: now,
        }
    }

    pub fn new_group(name: String) -> Self {
        let now = Utc::now();
        Self {
            id: Uuid::new_v4(),
            conversation_type: ConversationType::Group,
            name: Some(name),
            avatar_url: None,
            settings: serde_json::json!({}),
            created_at: now,
            updated_at: now,
        }
    }
}
