mod api;
mod application;
mod domain;
mod infrastructure;

use std::sync::Arc;
use api::{create_router, AppState};
use application::{
    LoginUser, RegisterUser, VerifyOtp, UploadPublicKey, GetPublicKey, 
    GetUploadUrl, SubmitKyc, ReviewKyc, 
    SendMessage, UpdateLocation, FindNearbyUsers, UpgradeSubscription, RegisterDeviceToken
};
use infrastructure::{
    AuthServiceImpl, Database, PostgresUserRepository, PostgresKycRepository, 
    PostgresMessageRepository, S3Service, MessageCleanupJob, RedisService,
    EvmBlockchainService
};
use tokio::sync::broadcast;
use anyhow::Context;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize tracing
    tracing_subscriber::fmt::init();

    // Load environment variables
    dotenvy::dotenv().ok();

    let database_url = std::env::var("DATABASE_URL").context("DATABASE_URL must be set")?;
    let jwt_secret = std::env::var("JWT_SECRET").context("JWT_SECRET must be set")?;
    let jwt_expiration: i64 = std::env::var("JWT_EXPIRATION")
        .unwrap_or_else(|_| "3600".to_string())
        .parse()
        .context("JWT_EXPIRATION must be a number")?;
        
    // S3 Config
    let s3_endpoint = std::env::var("S3_ENDPOINT").context("S3_ENDPOINT must be set")?;
    let s3_bucket = std::env::var("S3_BUCKET").context("S3_BUCKET must be set")?;
    let s3_access_key = std::env::var("S3_ACCESS_KEY").context("S3_ACCESS_KEY must be set")?;
    let s3_secret_key = std::env::var("S3_SECRET_KEY").context("S3_SECRET_KEY must be set")?;
    let s3_region = std::env::var("S3_REGION").context("S3_REGION must be set")?;

    // Redis Config
    let redis_url = std::env::var("REDIS_URL").context("REDIS_URL must be set")?;

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
        &s3_bucket,
        &s3_access_key,
        &s3_secret_key,
        &s3_region,
    ).await?);
    let redis_service = Arc::new(RedisService::new(&redis_url).await?); // Note: Redis service not fully used yet but initialized
    
    // Initialize Blockchain Service
    let rpc_url = std::env::var("RPC_URL").context("RPC_URL must be set")?;
    let blockchain_service = Arc::new(EvmBlockchainService::new(&rpc_url)?);

    // Initialize background jobs
    let cleanup_job = MessageCleanupJob::new(message_repo.clone());
    tokio::spawn(async move {
        cleanup_job.run().await;
    });

    // Initialize use cases
    let register_user = Arc::new(RegisterUser::new(user_repo.clone(), auth_service.clone()));
    let login_user = Arc::new(LoginUser::new(user_repo.clone(), auth_service.clone()));
    let verify_otp = Arc::new(VerifyOtp::new(auth_service.clone()));
    let upload_public_key = Arc::new(UploadPublicKey::new(user_repo.clone()));
    let get_public_key = Arc::new(GetPublicKey::new(user_repo.clone()));
    
    let get_upload_url = Arc::new(GetUploadUrl::new(s3_service.clone()));
    let submit_kyc = Arc::new(SubmitKyc::new(kyc_repo.clone()));
    let review_kyc = Arc::new(ReviewKyc::new(kyc_repo.clone()));
    
    let send_message = Arc::new(SendMessage::new(message_repo.clone()));
    
    let update_location = Arc::new(UpdateLocation::new(user_repo.clone()));
    let find_nearby_users = Arc::new(FindNearbyUsers::new(user_repo.clone()));
    
    let upgrade_subscription = Arc::new(UpgradeSubscription::new(user_repo.clone()));
    let register_device_token = Arc::new(RegisterDeviceToken::new(user_repo.clone()));

    // Initialize broadcast channel for WebSockets
    let (tx, _rx) = broadcast::channel(100);

    // Create app state
    let app_state = Arc::new(AppState {
        register_user,
        login_user,
        verify_otp,
        upload_public_key,
        get_public_key,
        get_upload_url,
        submit_kyc,
        review_kyc,
        send_message,
        update_location,
        find_nearby_users,
        upgrade_subscription,
        register_device_token,
        tx,
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
