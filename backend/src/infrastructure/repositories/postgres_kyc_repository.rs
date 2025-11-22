use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;

use crate::domain::{
    entities::{KycRequest, KycStatus},
    repositories::KycRepository,
    DomainError, DomainResult,
};

pub struct PostgresKycRepository {
    pool: PgPool,
}

impl PostgresKycRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl KycRepository for PostgresKycRepository {
    async fn create(&self, request: &KycRequest) -> DomainResult<KycRequest> {
        let status = match request.status {
            KycStatus::Pending => "Pending",
            KycStatus::Reviewing => "Reviewing",
            KycStatus::Approved => "Approved",
            KycStatus::Rejected => "Rejected",
        };

        let row = sqlx::query!(
            r#"
            INSERT INTO kyc_requests (id, user_id, front_doc_url, back_doc_url, selfie_url, status, created_at)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING id, user_id, front_doc_url, back_doc_url, selfie_url, status, admin_note, reviewed_by, created_at, reviewed_at
            "#,
            request.id,
            request.user_id,
            request.front_doc_url,
            request.back_doc_url,
            request.selfie_url,
            status,
            request.created_at
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(KycRequest {
            id: row.id,
            user_id: row.user_id,
            front_doc_url: row.front_doc_url,
            back_doc_url: row.back_doc_url,
            selfie_url: row.selfie_url,
            status: match row.status.as_deref() {
                Some("Reviewing") => KycStatus::Reviewing,
                Some("Approved") => KycStatus::Approved,
                Some("Rejected") => KycStatus::Rejected,
                _ => KycStatus::Pending,
            },
            admin_note: row.admin_note,
            reviewed_by: row.reviewed_by,
            created_at: row.created_at,
            reviewed_at: row.reviewed_at,
        })
    }

    async fn find_by_id(&self, id: Uuid) -> DomainResult<Option<KycRequest>> {
        let row = sqlx::query!(
            r#"
            SELECT id, user_id, front_doc_url, back_doc_url, selfie_url, status, admin_note, reviewed_by, created_at, reviewed_at
            FROM kyc_requests
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(row.map(|r| KycRequest {
            id: r.id,
            user_id: r.user_id,
            front_doc_url: r.front_doc_url,
            back_doc_url: r.back_doc_url,
            selfie_url: r.selfie_url,
            status: match r.status.as_deref() {
                Some("Reviewing") => KycStatus::Reviewing,
                Some("Approved") => KycStatus::Approved,
                Some("Rejected") => KycStatus::Rejected,
                _ => KycStatus::Pending,
            },
            admin_note: r.admin_note,
            reviewed_by: r.reviewed_by,
            created_at: r.created_at,
            reviewed_at: r.reviewed_at,
        }))
    }

    async fn find_by_user(&self, user_id: Uuid) -> DomainResult<Option<KycRequest>> {
        let row = sqlx::query!(
            r#"
            SELECT id, user_id, front_doc_url, back_doc_url, selfie_url, status, admin_note, reviewed_by, created_at, reviewed_at
            FROM kyc_requests
            WHERE user_id = $1
            ORDER BY created_at DESC
            LIMIT 1
            "#,
            user_id
        )
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(row.map(|r| KycRequest {
            id: r.id,
            user_id: r.user_id,
            front_doc_url: r.front_doc_url,
            back_doc_url: r.back_doc_url,
            selfie_url: r.selfie_url,
            status: match r.status.as_deref() {
                Some("Reviewing") => KycStatus::Reviewing,
                Some("Approved") => KycStatus::Approved,
                Some("Rejected") => KycStatus::Rejected,
                _ => KycStatus::Pending,
            },
            admin_note: r.admin_note,
            reviewed_by: r.reviewed_by,
            created_at: r.created_at,
            reviewed_at: r.reviewed_at,
        }))
    }

    async fn find_pending(&self) -> DomainResult<Vec<KycRequest>> {
        let rows = sqlx::query!(
            r#"
            SELECT id, user_id, front_doc_url, back_doc_url, selfie_url, status, admin_note, reviewed_by, created_at, reviewed_at
            FROM kyc_requests
            WHERE status = 'Pending'
            ORDER BY created_at ASC
            "#
        )
        .fetch_all(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(rows
            .into_iter()
            .map(|r| KycRequest {
                id: r.id,
                user_id: r.user_id,
                front_doc_url: r.front_doc_url,
                back_doc_url: r.back_doc_url,
                selfie_url: r.selfie_url,
                status: match r.status.as_deref() {
                    Some("Reviewing") => KycStatus::Reviewing,
                    Some("Approved") => KycStatus::Approved,
                    Some("Rejected") => KycStatus::Rejected,
                    _ => KycStatus::Pending,
                },
                admin_note: r.admin_note,
                reviewed_by: r.reviewed_by,
                created_at: r.created_at,
                reviewed_at: r.reviewed_at,
            })
            .collect())
    }

    async fn update(&self, request: &KycRequest) -> DomainResult<KycRequest> {
        let status = match request.status {
            KycStatus::Pending => "Pending",
            KycStatus::Reviewing => "Reviewing",
            KycStatus::Approved => "Approved",
            KycStatus::Rejected => "Rejected",
        };

        let row = sqlx::query!(
            r#"
            UPDATE kyc_requests
            SET status = $2, admin_note = $3, reviewed_by = $4, reviewed_at = $5
            WHERE id = $1
            RETURNING id, user_id, front_doc_url, back_doc_url, selfie_url, status, admin_note, reviewed_by, created_at, reviewed_at
            "#,
            request.id,
            status,
            request.admin_note,
            request.reviewed_by,
            request.reviewed_at
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(KycRequest {
            id: row.id,
            user_id: row.user_id,
            front_doc_url: row.front_doc_url,
            back_doc_url: row.back_doc_url,
            selfie_url: row.selfie_url,
            status: match row.status.as_deref() {
                Some("Reviewing") => KycStatus::Reviewing,
                Some("Approved") => KycStatus::Approved,
                Some("Rejected") => KycStatus::Rejected,
                _ => KycStatus::Pending,
            },
            admin_note: row.admin_note,
            reviewed_by: row.reviewed_by,
            created_at: row.created_at,
            reviewed_at: row.reviewed_at,
        })
    }
}
