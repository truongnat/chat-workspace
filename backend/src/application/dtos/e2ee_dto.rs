use serde::{Deserialize, Serialize};
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct UploadPublicKeyRequest {
    #[validate(length(min = 1))]
    pub public_key: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct PublicKeyResponse {
    pub public_key: Option<String>,
}
