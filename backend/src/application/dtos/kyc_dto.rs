use serde::{Deserialize, Serialize};
use validator::Validate;
use uuid::Uuid;
use chrono::{DateTime, Utc};

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct GetUploadUrlRequest {
    #[validate(length(min = 1))]
    pub filename: String,
    
    #[validate(length(min = 1))]
    pub content_type: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UploadUrlResponse {
    pub upload_url: String,
    pub file_url: String,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct SubmitKycRequest {
    #[validate(url)]
    pub front_doc_url: String,
    
    #[validate(url)]
    pub back_doc_url: Option<String>,
    
    #[validate(url)]
    pub selfie_url: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct KycResponse {
    pub id: Uuid,
    pub status: String,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct ReviewKycRequest {
    pub approved: bool,
    pub reason: Option<String>,
}
