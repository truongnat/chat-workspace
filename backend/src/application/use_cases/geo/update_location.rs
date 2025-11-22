use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    repositories::UserRepository,
    DomainResult,
};

pub struct UpdateLocation {
    user_repo: Arc<dyn UserRepository>,
}

impl UpdateLocation {
    pub fn new(user_repo: Arc<dyn UserRepository>) -> Self {
        Self { user_repo }
    }

    pub async fn execute(&self, user_id: Uuid, latitude: f64, longitude: f64) -> DomainResult<()> {
        self.user_repo.update_location(user_id, latitude, longitude).await
    }
}
