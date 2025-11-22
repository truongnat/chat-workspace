use axum::{
    extract::State,
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use serde_json::json;
use std::sync::Arc;
use validator::Validate;

use tokio::sync::broadcast;
use crate::application::{
    AuthResponse, LoginRequest, LoginUser, RegisterRequest, RegisterUser, VerifyOtpRequest, VerifyOtp,
    UploadPublicKey, GetPublicKey, UploadPublicKeyRequest, PublicKeyResponse,
    GetUploadUrl, SubmitKyc, ReviewKyc, SendMessage,
    UpdateLocation, FindNearbyUsers,
    UpgradeSubscription,
    RegisterDeviceToken,
};

pub struct AppState {
    pub register_user: Arc<RegisterUser>,
    pub login_user: Arc<LoginUser>,
    pub verify_otp: Arc<VerifyOtp>,
    pub upload_public_key: Arc<UploadPublicKey>,
    pub get_public_key: Arc<GetPublicKey>,
    pub get_upload_url: Arc<GetUploadUrl>,
    pub submit_kyc: Arc<SubmitKyc>,
    pub review_kyc: Arc<ReviewKyc>,
    pub send_message: Arc<SendMessage>,
    pub update_location: Arc<UpdateLocation>,
    pub find_nearby_users: Arc<FindNearbyUsers>,
    pub upgrade_subscription: Arc<UpgradeSubscription>,
    pub register_device_token: Arc<RegisterDeviceToken>,
    pub tx: broadcast::Sender<String>,
}

pub async fn register(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<RegisterRequest>,
) -> Result<Json<AuthResponse>, AppError> {
    payload.validate()?;

    let (user, token) = state
        .register_user
        .execute(payload.phone_number, payload.password)
        .await?;

    Ok(Json(AuthResponse {
        access_token: token,
        user_id: user.id.to_string(),
    }))
}

pub async fn login(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<LoginRequest>,
) -> Result<Json<AuthResponse>, AppError> {
    payload.validate()?;

    let (user, token) = state
        .login_user
        .execute(payload.phone_number, payload.password)
        .await?;

    Ok(Json(AuthResponse {
        access_token: token,
        user_id: user.id.to_string(),
    }))
}

pub async fn verify_otp(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<VerifyOtpRequest>,
) -> Result<StatusCode, AppError> {
    payload.validate()?;

    state
        .verify_otp
        .execute(payload.phone_number, payload.otp)
        .await?;

    Ok(StatusCode::OK)
}

pub async fn upload_public_key(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<UploadPublicKeyRequest>,
) -> Result<StatusCode, AppError> {
    payload.validate()?;
    
    // Mock user ID (TODO: Extract from JWT)
    let user_id = uuid::Uuid::new_v4();

    state
        .upload_public_key
        .execute(user_id, payload.public_key)
        .await?;

    Ok(StatusCode::OK)
}

pub async fn get_public_key(
    State(state): State<Arc<AppState>>,
    axum::extract::Path(user_id): axum::extract::Path<uuid::Uuid>,
) -> Result<Json<PublicKeyResponse>, AppError> {
    let public_key = state
        .get_public_key
        .execute(user_id)
        .await?;

    Ok(Json(PublicKeyResponse { public_key }))
}

// Error handling
pub struct AppError(anyhow::Error);

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let message = self.0.to_string();
        let body = Json(json!({
            "error": message
        }));

        (StatusCode::INTERNAL_SERVER_ERROR, body).into_response()
    }
}

impl<E> From<E> for AppError
where
    E: Into<anyhow::Error>,
{
    fn from(err: E) -> Self {
        Self(err.into())
    }
}
