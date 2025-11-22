use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{DomainResult, DomainError};
use crate::infrastructure::external::S3Service;

pub struct GetUploadUrl {
    s3_service: Arc<S3Service>,
}

impl GetUploadUrl {
    pub fn new(s3_service: Arc<S3Service>) -> Self {
        Self { s3_service }
    }

    pub async fn execute(&self, user_id: Uuid, filename: String, content_type: String) -> DomainResult<(String, String)> {
        // Generate a unique key for the file: kyc/{user_id}/{uuid}-{filename}
        let key = format!("kyc/{}/{}-{}", user_id, Uuid::new_v4(), filename);
        
        let upload_url = self.s3_service.get_presigned_url(&key, &content_type).await
            .map_err(|e| DomainError::InternalError(format!("S3 error: {}", e)))?;
            
        // The public URL (assuming bucket is public or served via CDN, 
        // but for KYC usually we want private. For now returning the key or a signed GET url would be better.
        // Here we return the key/path which can be stored in DB)
        let file_url = key; // In a real app, this might be a full URL or just the key

        Ok((upload_url, file_url))
    }
}
