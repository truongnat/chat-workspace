use aws_sdk_s3::{
    presigning::PresigningConfig,
    Client,
};
use std::time::Duration;
use anyhow::Result;

#[derive(Clone)]
pub struct S3Service {
    client: Client,
    bucket_name: String,
}

impl S3Service {
    pub async fn new(
        endpoint: &str,
        bucket_name: &str,
        access_key: &str,
        secret_key: &str,
        region: &str,
    ) -> Result<Self> {
        let config = aws_config::from_env()
            .endpoint_url(endpoint)
            .region(aws_sdk_s3::config::Region::new(region.to_string()))
            .credentials_provider(aws_sdk_s3::config::Credentials::new(
                access_key,
                secret_key,
                None,
                None,
                "static",
            ))
            .load()
            .await;

        let client = Client::new(&config);

        Ok(Self {
            client,
            bucket_name: bucket_name.to_string(),
        })
    }

    pub async fn get_presigned_url(&self, key: &str, content_type: &str) -> Result<String> {
        let expires_in = Duration::from_secs(3600); // 1 hour
        let presigned_request = self
            .client
            .put_object()
            .bucket(&self.bucket_name)
            .key(key)
            .content_type(content_type)
            .presigned(PresigningConfig::expires_in(expires_in)?)
            .await?;

        Ok(presigned_request.uri().to_string())
    }
}
