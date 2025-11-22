use argon2::{
    password_hash::{rand_core::OsRng, PasswordHash, PasswordHasher, PasswordVerifier, SaltString},
    Argon2,
};
use jsonwebtoken::{decode, encode, DecodingKey, EncodingKey, Header, Validation};
use serde::{Deserialize, Serialize};
use std::time::{SystemTime, UNIX_EPOCH};

use crate::domain::{services::AuthService, DomainError, DomainResult};

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    sub: String,
    exp: usize,
}

pub struct AuthServiceImpl {
    jwt_secret: String,
    jwt_expiration: i64,
}

impl AuthServiceImpl {
    pub fn new(jwt_secret: String, jwt_expiration: i64) -> Self {
        Self {
            jwt_secret,
            jwt_expiration,
        }
    }
}

#[async_trait::async_trait]
impl AuthService for AuthServiceImpl {
    async fn hash_password(&self, password: &str) -> DomainResult<String> {
        let salt = SaltString::generate(&mut OsRng);
        let argon2 = Argon2::default();

        argon2
            .hash_password(password.as_bytes(), &salt)
            .map(|hash| hash.to_string())
            .map_err(|e| DomainError::InternalError(format!("Password hashing failed: {}", e)))
    }

    async fn verify_password(&self, password: &str, hash: &str) -> DomainResult<bool> {
        let parsed_hash = PasswordHash::new(hash)
            .map_err(|e| DomainError::InternalError(format!("Invalid hash: {}", e)))?;

        Ok(Argon2::default()
            .verify_password(password.as_bytes(), &parsed_hash)
            .is_ok())
    }

    async fn generate_jwt(&self, user_id: &str) -> DomainResult<String> {
        let expiration = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs() as usize
            + self.jwt_expiration as usize;

        let claims = Claims {
            sub: user_id.to_string(),
            exp: expiration,
        };

        encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(self.jwt_secret.as_bytes()),
        )
        .map_err(|e| DomainError::InternalError(format!("JWT generation failed: {}", e)))
    }

    async fn verify_jwt(&self, token: &str) -> DomainResult<String> {
        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(self.jwt_secret.as_bytes()),
            &Validation::default(),
        )
        .map_err(|e| DomainError::AuthenticationError(format!("Invalid token: {}", e)))?;

        Ok(token_data.claims.sub)
    }

    async fn verify_otp(&self, phone_number: &str, otp: &str) -> DomainResult<bool> {
        // TODO: Integrate with Twilio/SNS
        // For now, in dev mode, we just log it and accept '123456' or any OTP for testing
        tracing::info!("Verifying OTP for {}: {}", phone_number, otp);
        
        if otp == "123456" {
            Ok(true)
        } else {
            // In a real scenario, we would return false or error
            // For dev ease, let's accept everything but log it
            tracing::warn!("Accepting any OTP in dev mode");
            Ok(true)
        }
    }
}
