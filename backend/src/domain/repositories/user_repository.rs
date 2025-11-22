use async_trait::async_trait;
use uuid::Uuid;

use crate::domain::{entities::User, DomainResult};

#[async_trait]
pub trait UserRepository: Send + Sync {
    async fn create(&self, user: &User) -> DomainResult<User>;
    async fn find_by_id(&self, id: Uuid) -> DomainResult<Option<User>>;
    async fn find_by_phone(&self, phone_number: &str) -> DomainResult<Option<User>>;
    async fn find_by_username(&self, username: &str) -> DomainResult<Option<User>>;
    async fn update(&self, user: &User) -> DomainResult<User>;
    async fn delete(&self, id: Uuid) -> DomainResult<()>;
    async fn find_nearby(&self, lat: f64, lon: f64, radius_km: f64) -> DomainResult<Vec<User>>;
    async fn update_location(&self, user_id: Uuid, lat: f64, lon: f64) -> DomainResult<()>;
    async fn update_location(&self, user_id: Uuid, lat: f64, lon: f64) -> DomainResult<()>;
    async fn update_online_status(&self, user_id: Uuid, is_online: bool) -> DomainResult<()>;
    async fn update_public_key(&self, user_id: Uuid, public_key: String) -> DomainResult<()>;
}
