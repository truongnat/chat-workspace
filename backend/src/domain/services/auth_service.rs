use async_trait::async_trait;

use crate::domain::DomainResult;

#[async_trait]
pub trait AuthService: Send + Sync {
    async fn hash_password(&self, password: &str) -> DomainResult<String>;
    async fn verify_password(&self, password: &str, hash: &str) -> DomainResult<bool>;
    async fn generate_jwt(&self, user_id: &str) -> DomainResult<String>;
    async fn verify_jwt(&self, token: &str) -> DomainResult<String>;
    async fn verify_otp(&self, phone_number: &str, otp: &str) -> DomainResult<bool>;
}
