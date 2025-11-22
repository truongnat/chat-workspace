use axum::{
    extract::{State, Json},
};
use std::sync::Arc;
use uuid::Uuid;
use validator::Validate;

use crate::application::{
    UpgradeSubscriptionRequest, SubscriptionResponse,
    UpgradeSubscription,
};
use crate::api::handlers::{AppError, AppState};

// TODO: Extract user ID from JWT
// For now, mock user ID

pub async fn upgrade_subscription(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<UpgradeSubscriptionRequest>,
) -> Result<Json<SubscriptionResponse>, AppError> {
    payload.validate()?;
    
    // Mock user ID
    let user_id = Uuid::new_v4();

    let response = state
        .upgrade_subscription
        .execute(user_id, payload.tier)
        .await?;

    Ok(Json(response))
}
