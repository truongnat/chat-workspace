use axum::{
    extract::{State, Json, Extension},
};
use crate::api::middleware::auth_middleware::CurrentUser;
use std::sync::Arc;
use uuid::Uuid;
use validator::Validate;

use crate::application::{
    UpgradeSubscriptionRequest, SubscriptionResponse,
    UpgradeSubscription,
};
use crate::api::handlers::{AppError, AppState};

pub async fn upgrade_subscription(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(payload): Json<UpgradeSubscriptionRequest>,
) -> Result<Json<SubscriptionResponse>, AppError> {
    payload.validate()?;
    
    let user_id = current_user.id;

    let response = state
        .upgrade_subscription
        .execute(user_id, payload.tier)
        .await?;

    Ok(Json(response))
}
