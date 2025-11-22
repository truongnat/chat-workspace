use async_trait::async_trait;
use uuid::Uuid;

use crate::domain::{entities::KycRequest, DomainResult};

#[async_trait]
pub trait KycRepository: Send + Sync {
    async fn create(&self, request: &KycRequest) -> DomainResult<KycRequest>;
    async fn find_by_id(&self, id: Uuid) -> DomainResult<Option<KycRequest>>;
    async fn find_by_user(&self, user_id: Uuid) -> DomainResult<Option<KycRequest>>;
    async fn find_pending(&self) -> DomainResult<Vec<KycRequest>>;
    async fn update(&self, request: &KycRequest) -> DomainResult<KycRequest>;
}
