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
    AuthResponse, LoginRequest, LoginUser, RegisterRequest, RegisterUser,
    GetUploadUrl, SubmitKyc, ReviewKyc, SendMessage,
};

pub struct AppState {
    pub register_user: Arc<RegisterUser>,
    pub login_user: Arc<LoginUser>,
    pub get_upload_url: Arc<GetUploadUrl>,
    pub submit_kyc: Arc<SubmitKyc>,
    pub review_kyc: Arc<ReviewKyc>,
    pub send_message: Arc<SendMessage>,
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
