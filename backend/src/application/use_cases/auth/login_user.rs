use std::sync::Arc;

use crate::domain::{
    entities::User,
    repositories::UserRepository,
    services::AuthService,
    DomainError, DomainResult,
};

pub struct LoginUser {
    user_repo: Arc<dyn UserRepository>,
    auth_service: Arc<dyn AuthService>,
}

impl LoginUser {
    pub fn new(user_repo: Arc<dyn UserRepository>, auth_service: Arc<dyn AuthService>) -> Self {
        Self {
            user_repo,
            auth_service,
        }
    }

    pub async fn execute(&self, phone_number: String, password: String) -> DomainResult<(User, String)> {
        // Find user by phone
        let user = self
            .user_repo
            .find_by_phone(&phone_number)
            .await?
            .ok_or_else(|| DomainError::AuthenticationError("Invalid credentials".to_string()))?;

        // Verify password
        let is_valid = self
            .auth_service
            .verify_password(&password, &user.password_hash)
            .await?;

        if !is_valid {
            return Err(DomainError::AuthenticationError(
                "Invalid credentials".to_string(),
            ));
        }

        // Generate JWT
        let token = self.auth_service.generate_jwt(&user.id.to_string()).await?;

        Ok((user, token))
    }
}
