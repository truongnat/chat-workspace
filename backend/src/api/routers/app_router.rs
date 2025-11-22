use axum::{routing::post, Router};
use std::sync::Arc;

use super::handlers::AppState;

pub fn create_router(state: Arc<AppState>) -> Router {
    Router::new()
        .route("/api/auth/register", post(super::handlers::register))
        .route("/api/auth/login", post(super::handlers::login))
        .with_state(state)
}
