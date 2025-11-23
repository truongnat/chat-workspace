use axum::{
    extract::{State, Json, Extension},
    http::StatusCode,
};
use crate::api::middleware::auth_middleware::CurrentUser;
use std::sync::Arc;
use uuid::Uuid;
use validator::Validate;

use crate::application::RegisterDeviceTokenRequest;
use crate::api::handlers::{AppError, AppState};

pub async fn register_device_token(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(payload): Json<RegisterDeviceTokenRequest>,
) -> Result<StatusCode, AppError> {
    payload.validate()?;
    
    let user_id = current_user.id;

    state
        .register_device_token
        .execute(user_id, payload.token)
        .await?;

    Ok(StatusCode::OK)
}
