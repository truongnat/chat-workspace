use serde::{Deserialize, Serialize};
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct RegisterDeviceTokenRequest {
    #[validate(length(min = 1))]
    pub token: String,
    
    pub platform: Option<String>, // "android", "ios", "web"
}
