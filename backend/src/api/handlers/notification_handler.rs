use axum::{
    extract::{State, Json},
    http::StatusCode,
};
use std::sync::Arc;
use uuid::Uuid;
use validator::Validate;

use crate::application::RegisterDeviceTokenRequest;
use crate::api::handlers::{AppError, AppState};

// TODO: Extract user ID from JWT
// For now, mock user ID

pub async fn register_device_token(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<RegisterDeviceTokenRequest>,
) -> Result<StatusCode, AppError> {
    payload.validate()?;
    
    // Mock user ID
    let user_id = Uuid::new_v4();

    state
        .register_device_token
        .execute(user_id, payload.token)
        .await?;

    Ok(StatusCode::OK)
}
