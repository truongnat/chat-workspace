use std::sync::Arc;
use uuid::Uuid;

use crate::domain::{
    entities::{KycRequest, KycStatus},
    repositories::{KycRepository, UserRepository},
    DomainError, DomainResult,
};

pub struct ReviewKyc {
    kyc_repo: Arc<dyn KycRepository>,
    user_repo: Arc<dyn UserRepository>,
}

impl ReviewKyc {
    pub fn new(kyc_repo: Arc<dyn KycRepository>, user_repo: Arc<dyn UserRepository>) -> Self {
        Self { kyc_repo, user_repo }
    }

    pub async fn execute(
        &self,
        reviewer_id: Uuid,
        request_id: Uuid,
        approved: bool,
        reason: Option<String>,
    ) -> DomainResult<KycRequest> {
        let mut request = self.kyc_repo.find_by_id(request_id).await?
            .ok_or_else(|| DomainError::NotFound("KYC request not found".to_string()))?;

        if request.status != KycStatus::Pending && request.status != KycStatus::Reviewing {
            return Err(DomainError::Conflict("KYC request is already processed".to_string()));
        }

        if approved {
            request.approve(reviewer_id);
            
            // Update user verification status
            if let Some(mut user) = self.user_repo.find_by_id(request.user_id).await? {
                user.is_verified = true;
                self.user_repo.update(&user).await?;
            }
        } else {
            request.reject(reviewer_id, reason.unwrap_or_default());
        }

        self.kyc_repo.update(&request).await
    }
}
