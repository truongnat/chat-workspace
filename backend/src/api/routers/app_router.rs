use axum::{routing::post, Router};
use std::sync::Arc;

use super::handlers::AppState;

pub fn create_router(state: Arc<AppState>) -> Router {
    Router::new()
        .route("/api/auth/register", post(super::handlers::register))
        .route("/api/auth/login", post(super::handlers::login))
        .route("/api/kyc/upload-url", post(super::handlers::get_upload_url))
        .route("/api/kyc/submit", post(super::handlers::submit_kyc))
        .route("/api/admin/kyc/:id/review", post(super::handlers::review_kyc))
        .route("/ws", axum::routing::get(crate::api::ws::ws_handler))
        .with_state(state)
}
