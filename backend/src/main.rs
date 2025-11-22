mod api;
mod application;
mod domain;
mod infrastructure;

use std::sync::Arc;

use api::{create_router, AppState};
use application::{LoginUser, RegisterUser};
use infrastructure::{AuthServiceImpl, Database, PostgresUserRepository};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize tracing
    tracing_subscriber::fmt::init();

    // Load environment variables
    dotenvy::dotenv().ok();

    let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let jwt_secret = std::env::var("JWT_SECRET").expect("JWT_SECRET must be set");
    let jwt_expiration: i64 = std::env::var("JWT_EXPIRATION")
        .unwrap_or_else(|_| "3600".to_string())
        .parse()
        .expect("JWT_EXPIRATION must be a number");

    // Initialize database
    let db = Database::new(&database_url).await?;
    tracing::info!("Database connected");

    // Initialize repositories
    let user_repo = Arc::new(PostgresUserRepository::new(db.pool().clone()));

    // Initialize services
    let auth_service = Arc::new(AuthServiceImpl::new(jwt_secret, jwt_expiration));

    // Initialize use cases
    let register_user = Arc::new(RegisterUser::new(user_repo.clone(), auth_service.clone()));
    let login_user = Arc::new(LoginUser::new(user_repo.clone(), auth_service.clone()));

    // Create app state
    let app_state = Arc::new(AppState {
        register_user,
        login_user,
    });

    // Create router
    let app = create_router(app_state);

    // Start server
    let addr = "0.0.0.0:8080";
    tracing::info!("Server listening on {}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}
