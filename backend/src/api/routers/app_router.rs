use axum::{routing::post, Router};
use std::sync::Arc;
use tower_governor::{governor::GovernorConfigBuilder, GovernorLayer};

use super::handlers::AppState;

pub fn create_router(state: Arc<AppState>) -> Router {
    let governor_conf = Box::new(GovernorConfigBuilder::default().finish().unwrap());

    Router::new()
        .route("/api/auth/register", post(super::handlers::register))
        .route("/api/auth/login", post(super::handlers::login).layer(GovernorLayer { config: governor_conf.clone() }))
        .route("/api/auth/verify-otp", post(super::handlers::verify_otp).layer(GovernorLayer { config: governor_conf }))
        // Protected Routes
        .route("/api/keys/upload", post(super::handlers::upload_public_key))
        .route("/api/users/:id/key", axum::routing::get(super::handlers::get_public_key))
        .route("/api/kyc/upload-url", post(super::handlers::get_upload_url))
        .route("/api/kyc/submit", post(super::handlers::submit_kyc))
        .route("/api/admin/kyc/:id/review", post(super::handlers::review_kyc))
        .route("/api/geo/location", post(super::handlers::update_location))
        .route("/api/geo/nearby", axum::routing::get(super::handlers::find_nearby))
        .route("/api/subscriptions/upgrade", post(super::handlers::upgrade_subscription))
        .route("/api/notifications/device-token", post(super::handlers::register_device_token))
        .route_layer(axum::middleware::from_fn_with_state(state.clone(), crate::api::middleware::auth_middleware::auth_middleware))
        // WebSocket
        .route("/ws", axum::routing::get(crate::api::ws::ws_handler))
        .with_state(state)
}
