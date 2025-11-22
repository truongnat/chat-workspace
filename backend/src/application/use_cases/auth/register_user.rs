use std::sync::Arc;

use crate::domain::{
    entities::User,
    repositories::UserRepository,
    services::AuthService,
    DomainResult,
};

pub struct RegisterUser {
    user_repo: Arc<dyn UserRepository>,
    auth_service: Arc<dyn AuthService>,
}

impl RegisterUser {
    pub fn new(user_repo: Arc<dyn UserRepository>, auth_service: Arc<dyn AuthService>) -> Self {
        Self {
            user_repo,
            auth_service,
        }
    }

    pub async fn execute(&self, phone_number: String, password: String) -> DomainResult<(User, String)> {
        // Check if user already exists
        if let Some(_) = self.user_repo.find_by_phone(&phone_number).await? {
            return Err(crate::domain::DomainError::Conflict(
                "User already exists".to_string(),
            ));
        }

        // Hash password
        let password_hash = self.auth_service.hash_password(&password).await?;

        // Create user
        let user = User::new(phone_number, password_hash);
        let created_user = self.user_repo.create(&user).await?;

        // Generate JWT
        let token = self.auth_service.generate_jwt(&created_user.id.to_string()).await?;

        Ok((created_user, token))
    }
}
