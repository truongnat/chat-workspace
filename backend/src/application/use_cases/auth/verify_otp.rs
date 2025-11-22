use std::sync::Arc;

use crate::domain::{
    services::AuthService,
    DomainResult,
};

pub struct VerifyOtp {
    auth_service: Arc<dyn AuthService>,
}

impl VerifyOtp {
    pub fn new(auth_service: Arc<dyn AuthService>) -> Self {
        Self { auth_service }
    }

    pub async fn execute(&self, phone_number: String, otp: String) -> DomainResult<()> {
        let is_valid = self.auth_service.verify_otp(&phone_number, &otp).await?;
        
        if is_valid {
            Ok(())
        } else {
            Err(crate::domain::DomainError::AuthenticationError("Invalid OTP".to_string()))
        }
    }
}
