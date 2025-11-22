use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    entities::{KycRequest, KycStatus},
    repositories::KycRepository,
    DomainError, DomainResult,
};

pub struct SubmitKyc {
    kyc_repo: Arc<dyn KycRepository>,
}

impl SubmitKyc {
    pub fn new(kyc_repo: Arc<dyn KycRepository>) -> Self {
        Self { kyc_repo }
    }

    pub async fn execute(
        &self,
        user_id: Uuid,
        front_doc_url: String,
        back_doc_url: Option<String>,
        selfie_url: String,
    ) -> DomainResult<KycRequest> {
        // Check if user already has a pending or approved request
        if let Some(existing) = self.kyc_repo.find_by_user(user_id).await? {
            if existing.status == KycStatus::Pending || existing.status == KycStatus::Approved {
                return Err(DomainError::Conflict("User already has a pending or approved KYC request".to_string()));
            }
        }

        let mut request = KycRequest::new(user_id, front_doc_url, selfie_url);
        request.back_doc_url = back_doc_url;

        self.kyc_repo.create(&request).await
    }
}
