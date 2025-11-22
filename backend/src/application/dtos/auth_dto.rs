use serde::{Deserialize, Serialize};
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct RegisterRequest {
    #[validate(length(min = 10, max = 20))]
    pub phone_number: String,
    
    #[validate(length(min = 6))]
    pub password: String,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct LoginRequest {
    #[validate(length(min = 10, max = 20))]
    pub phone_number: String,
    
    #[validate(length(min = 6))]
    pub password: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct AuthResponse {
    pub access_token: String,
    pub user_id: String,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct VerifyOtpRequest {
    #[validate(length(min = 10, max = 20))]
    pub phone_number: String,
    
    #[validate(length(equal = 6))]
    pub otp: String,
}
