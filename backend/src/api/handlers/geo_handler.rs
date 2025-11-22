use axum::{
    extract::{State, Query},
    Json,
};
use std::sync::Arc;
use uuid::Uuid;
use validator::Validate;

use crate::application::{
    UpdateLocationRequest, FindNearbyRequest, UserLocationResponse,
    UpdateLocation, FindNearbyUsers,
};
use crate::api::handlers::{AppError, AppState};

// TODO: Extract user ID from JWT
// For now, mock user ID

pub async fn update_location(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<UpdateLocationRequest>,
) -> Result<Json<()>, AppError> {
    payload.validate()?;
    
    // Mock user ID
    let user_id = Uuid::new_v4();

    state
        .update_location
        .execute(user_id, payload.latitude, payload.longitude)
        .await?;

    Ok(Json(()))
}

pub async fn find_nearby(
    State(state): State<Arc<AppState>>,
    Query(payload): Query<FindNearbyRequest>,
) -> Result<Json<Vec<UserLocationResponse>>, AppError> {
    payload.validate()?;

    let users = state
        .find_nearby_users
        .execute(payload.latitude, payload.longitude, payload.radius_km)
        .await?;

    Ok(Json(users))
}
