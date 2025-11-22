use axum::{
    extract::{Path, State},
    http::StatusCode,
    Json,
    response::IntoResponse,
};
use std::sync::Arc;
use uuid::Uuid;
use validator::Validate;

use crate::application::{
    GetUploadUrlRequest, UploadUrlResponse,
    SubmitKycRequest, KycResponse,
    ReviewKycRequest,
    GetUploadUrl, SubmitKyc, ReviewKyc,
};
use crate::api::handlers::{AppError, AppState};

// TODO: Extract user ID from JWT middleware
// For now, we'll assume a mock user ID or pass it in headers for testing
// In a real app, use axum::extract::Extension or a custom extractor

pub async fn get_upload_url(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<GetUploadUrlRequest>,
) -> Result<Json<UploadUrlResponse>, AppError> {
    payload.validate()?;
    
    // Mock user ID for now - replace with actual auth
    let user_id = Uuid::new_v4(); 

    let (upload_url, file_url) = state
        .get_upload_url
        .execute(user_id, payload.filename, payload.content_type)
        .await?;

    Ok(Json(UploadUrlResponse {
        upload_url,
        file_url,
    }))
}

pub async fn submit_kyc(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<SubmitKycRequest>,
) -> Result<Json<KycResponse>, AppError> {
    payload.validate()?;

    // Mock user ID for now
    let user_id = Uuid::new_v4();

    let request = state
        .submit_kyc
        .execute(
            user_id,
            payload.front_doc_url,
            payload.back_doc_url,
            payload.selfie_url,
        )
        .await?;

    Ok(Json(KycResponse {
        id: request.id,
        status: format!("{:?}", request.status),
        created_at: request.created_at,
    }))
}

pub async fn review_kyc(
    State(state): State<Arc<AppState>>,
    Path(request_id): Path<Uuid>,
    Json(payload): Json<ReviewKycRequest>,
) -> Result<Json<KycResponse>, AppError> {
    // Mock admin ID
    let admin_id = Uuid::new_v4();

    let request = state
        .review_kyc
        .execute(admin_id, request_id, payload.approved, payload.reason)
        .await?;

    Ok(Json(KycResponse {
        id: request.id,
        status: format!("{:?}", request.status),
        created_at: request.created_at,
    }))
}
