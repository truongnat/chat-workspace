use async_trait::async_trait;
use crate::domain::{services::NotificationService, DomainResult};
use reqwest::Client;
use serde_json::json;

pub struct FcmService {
    server_key: Option<String>,
    client: Client,
}

impl FcmService {
    pub fn new() -> Self {
        let server_key = std::env::var("FCM_SERVER_KEY").ok();
        
        if server_key.is_none() {
            tracing::warn!("FCM_SERVER_KEY not set. FCM notifications will be mocked.");
        }
        
        Self {
            server_key,
            client: Client::new(),
        }
    }
}

#[async_trait]
impl NotificationService for FcmService {
    async fn send_notification(&self, user_id: &str, title: &str, body: &str, data: Option<serde_json::Value>) -> DomainResult<()> {
        // If FCM_SERVER_KEY is not set, just log (mock mode)
        let Some(server_key) = &self.server_key else {
            tracing::info!(
                "🚀 [FCM Mock] Sending to User {}: Title='{}', Body='{}'",
                user_id, title, body
            );
            return Ok(());
        };

        // Real FCM implementation
        // Note: In production, you should fetch the device token from database using user_id
        // For now, we'll assume user_id is the device token or you need to look it up
        
        let fcm_url = "https://fcm.googleapis.com/fcm/send";
        let payload = json!({
            "to": user_id, // In production, this should be the device token
            "notification": {
                "title": title,
                "body": body,
            },
            "data": data.unwrap_or(json!({})),
        });

        let response = self.client
            .post(fcm_url)
            .header("Authorization", format!("key={}", server_key))
            .header("Content-Type", "application/json")
            .json(&payload)
            .send()
            .await
            .map_err(|e| format!("FCM request failed: {}", e))?;

        if !response.status().is_success() {
            let error_text = response.text().await.unwrap_or_default();
            tracing::error!("FCM error: {}", error_text);
            return Err(format!("FCM failed: {}", error_text));
        }

        tracing::info!("✅ FCM notification sent to user {}", user_id);
        Ok(())
    }
}
