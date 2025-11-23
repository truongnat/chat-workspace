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
        let expiration = chrono::Utc::now().timestamp() as usize + self.jwt_expiration as usize;

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
        // Check if Twilio credentials are set
        let twilio_account_sid = std::env::var("TWILIO_ACCOUNT_SID").ok();
        let twilio_auth_token = std::env::var("TWILIO_AUTH_TOKEN").ok();
        let twilio_verify_sid = std::env::var("TWILIO_VERIFY_SID").ok();

        // If Twilio is not configured, use mock mode
        if twilio_account_sid.is_none() || twilio_auth_token.is_none() || twilio_verify_sid.is_none() {
            tracing::warn!("Twilio not configured. Using mock OTP verification.");
            tracing::info!("Verifying OTP for {}: {}", phone_number, otp);
            
            // Mock mode: accept "123456" as valid OTP
            if otp == "123456" {
                return Ok(true);
            } else {
                tracing::warn!("Invalid OTP attempt for {}", phone_number);
                return Ok(false);
            }
        }

        // Real Twilio Verify API integration
        let account_sid = twilio_account_sid.unwrap();
        let auth_token = twilio_auth_token.unwrap();
        let verify_sid = twilio_verify_sid.unwrap();

        let client = reqwest::Client::new();
        let url = format!(
            "https://verify.twilio.com/v2/Services/{}/VerificationCheck",
            verify_sid
        );

        let response = client
            .post(&url)
            .basic_auth(&account_sid, Some(&auth_token))
            .form(&[("To", phone_number), ("Code", otp)])
            .send()
            .await
            .map_err(|e| DomainError::InternalError(format!("Twilio request failed: {}", e)))?;

        if !response.status().is_success() {
            let error_text = response.text().await.unwrap_or_default();
            tracing::error!("Twilio OTP verification failed: {}", error_text);
            return Ok(false);
        }

        let result: serde_json::Value = response
            .json()
            .await
            .map_err(|e| DomainError::InternalError(format!("Failed to parse Twilio response: {}", e)))?;

        // Check if verification was approved
        let is_valid = result["status"].as_str() == Some("approved");
        
        if is_valid {
            tracing::info!("✅ OTP verified successfully for {}", phone_number);
        } else {
            tracing::warn!("❌ Invalid OTP for {}", phone_number);
        }

        Ok(is_valid)
    }
}
