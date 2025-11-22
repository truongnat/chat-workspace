use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    repositories::UserRepository,
    DomainResult,
};

pub struct UploadPublicKey {
    user_repo: Arc<dyn UserRepository>,
}

impl UploadPublicKey {
    pub fn new(user_repo: Arc<dyn UserRepository>) -> Self {
        Self { user_repo }
    }

    pub async fn execute(&self, user_id: Uuid, public_key: String) -> DomainResult<()> {
        self.user_repo.update_public_key(user_id, public_key).await
    }
}
