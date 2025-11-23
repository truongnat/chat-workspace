use axum::{
    extract::{Path, State},
    http::StatusCode,
    Json,
    response::IntoResponse,
    Extension,
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
use crate::api::middleware::auth_middleware::CurrentUser;

pub async fn get_upload_url(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(payload): Json<GetUploadUrlRequest>,
) -> Result<Json<UploadUrlResponse>, AppError> {
    payload.validate()?;
    
    let user_id = current_user.id;

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
    Extension(current_user): Extension<CurrentUser>,
    Json(payload): Json<SubmitKycRequest>,
) -> Result<Json<KycResponse>, AppError> {
    payload.validate()?;

    let user_id = current_user.id;

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
    Extension(current_user): Extension<CurrentUser>,
    Path(request_id): Path<Uuid>,
    Json(payload): Json<ReviewKycRequest>,
) -> Result<Json<KycResponse>, AppError> {
    let admin_id = current_user.id;

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
