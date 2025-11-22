mod api;
mod application;
mod domain;
mod infrastructure;

use std::sync::Arc;

use api::{create_router, AppState};
use application::{LoginUser, RegisterUser, GetUploadUrl, SubmitKyc, ReviewKyc, SendMessage};
use infrastructure::{AuthServiceImpl, Database, PostgresUserRepository, PostgresKycRepository, PostgresMessageRepository, S3Service};
use tokio::sync::broadcast;

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
        
    // S3 Config
    let s3_endpoint = std::env::var("S3_ENDPOINT").expect("S3_ENDPOINT must be set");
    let s3_bucket = std::env::var("S3_BUCKET").expect("S3_BUCKET must be set");
    let s3_access_key = std::env::var("S3_ACCESS_KEY").expect("S3_ACCESS_KEY must be set");
    let s3_secret_key = std::env::var("S3_SECRET_KEY").expect("S3_SECRET_KEY must be set");
    let s3_region = std::env::var("S3_REGION").expect("S3_REGION must be set");

    // Initialize database
    let db = Database::new(&database_url).await?;
    tracing::info!("Database connected");

    // Initialize repositories
    let user_repo = Arc::new(PostgresUserRepository::new(db.pool().clone()));
    let kyc_repo = Arc::new(PostgresKycRepository::new(db.pool().clone()));
    let message_repo = Arc::new(PostgresMessageRepository::new(db.pool().clone()));

    // Initialize services
    let auth_service = Arc::new(AuthServiceImpl::new(jwt_secret, jwt_expiration));
    let s3_service = Arc::new(S3Service::new(
        &s3_endpoint, 
    // Start server
    let addr = "0.0.0.0:8080";
    tracing::info!("Server listening on {}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}
