use redis::{Client, Commands, PubSubCommands};
use std::sync::Arc;
use tokio::sync::broadcast;
use anyhow::Result;
use serde::{Deserialize, Serialize};

#[derive(Clone)]
pub struct RedisService {
    client: Client,
}

impl RedisService {
    pub fn new(redis_url: &str) -> Result<Self> {
        let client = Client::open(redis_url)?;
        Ok(Self { client })
    }

    pub async fn publish(&self, channel: &str, message: &str) -> Result<()> {
        let mut con = self.client.get_async_connection().await?;
        redis::cmd("PUBLISH")
            .arg(channel)
            .arg(message)
            .query_async(&mut con)
            .await?;
        Ok(())
    }

    pub async fn subscribe(&self, channel: &str) -> Result<redis::aio::PubSub> {
        let con = self.client.get_async_connection().await?;
        let mut pubsub = con.into_pubsub();
        pubsub.subscribe(channel).await?;
        Ok(pubsub)
    }
}
