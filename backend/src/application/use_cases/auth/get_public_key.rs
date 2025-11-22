use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    repositories::UserRepository,
    DomainResult, DomainError,
};

pub struct GetPublicKey {
    user_repo: Arc<dyn UserRepository>,
}

impl GetPublicKey {
    pub fn new(user_repo: Arc<dyn UserRepository>) -> Self {
        Self { user_repo }
    }

    pub async fn execute(&self, user_id: Uuid) -> DomainResult<Option<String>> {
        let user = self.user_repo.find_by_id(user_id).await?;
        
        match user {
            Some(u) => Ok(u.public_key),
            None => Err(DomainError::EntityNotFound("User not found".to_string())),
        }
    }
}
