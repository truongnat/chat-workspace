use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct KycRequest {
    pub id: Uuid,
    pub user_id: Uuid,
    pub front_doc_url: String,
    pub back_doc_url: Option<String>,
    pub selfie_url: String,
    pub status: KycStatus,
    pub admin_note: Option<String>,
    pub reviewed_by: Option<Uuid>,
    pub created_at: DateTime<Utc>,
    pub reviewed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum KycStatus {
    Pending,
    Reviewing,
    Approved,
    Rejected,
}

impl KycRequest {
    pub fn new(user_id: Uuid, front_doc_url: String, selfie_url: String) -> Self {
        Self {
            id: Uuid::new_v4(),
            user_id,
            front_doc_url,
            back_doc_url: None,
            selfie_url,
            status: KycStatus::Pending,
            admin_note: None,
            reviewed_by: None,
            created_at: Utc::now(),
            reviewed_at: None,
        }
    }

    pub fn approve(&mut self, reviewer_id: Uuid) {
        self.status = KycStatus::Approved;
        self.reviewed_by = Some(reviewer_id);
        self.reviewed_at = Some(Utc::now());
    }

    pub fn reject(&mut self, reviewer_id: Uuid, reason: String) {
        self.status = KycStatus::Rejected;
        self.reviewed_by = Some(reviewer_id);
        self.admin_note = Some(reason);
        self.reviewed_at = Some(Utc::now());
    }
}
