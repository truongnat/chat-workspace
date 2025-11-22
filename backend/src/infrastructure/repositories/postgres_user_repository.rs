use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;

use crate::domain::{
    entities::{SubscriptionTier, User},
    repositories::UserRepository,
    DomainError, DomainResult,
};

pub struct PostgresUserRepository {
    pool: PgPool,
}

impl PostgresUserRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl UserRepository for PostgresUserRepository {
    async fn create(&self, user: &User) -> DomainResult<User> {
        let subscription_tier = match user.subscription_tier {
            SubscriptionTier::Free => "Free",
            SubscriptionTier::Monthly => "Monthly",
            SubscriptionTier::Yearly => "Yearly",
        };

        let row = sqlx::query!(
            r#"
            INSERT INTO users (id, phone_number, password_hash, name, username, bio, avatar_url, is_verified, subscription_tier, public_key_x25519)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            RETURNING id, phone_number, password_hash, name, username, bio, avatar_url, 
                      is_verified, is_online, last_seen, subscription_tier, created_at, updated_at, public_key_x25519
            "#,
            user.id,
            user.phone_number,
            user.password_hash,
            user.name,
            user.username,
            user.bio,
            user.avatar_url,
            user.is_verified,
            subscription_tier,
            user.public_key
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(User {
            id: row.id,
            phone_number: row.phone_number,
            password_hash: row.password_hash,
            name: row.name,
            username: row.username,
            bio: row.bio,
            avatar_url: row.avatar_url,
            location: None,
            public_key: row.public_key_x25519,
            is_verified: row.is_verified,
            is_online: row.is_online,
            last_seen: row.last_seen,
            subscription_tier: match row.subscription_tier.as_str() {
                "Monthly" => SubscriptionTier::Monthly,
                "Yearly" => SubscriptionTier::Yearly,
                _ => SubscriptionTier::Free,
            },
            created_at: row.created_at,
            updated_at: row.updated_at,
        })
    }

    async fn find_by_id(&self, id: Uuid) -> DomainResult<Option<User>> {
        let row = sqlx::query!(
            r#"
            SELECT id, phone_number, password_hash, name, username, bio, avatar_url,
                   is_verified, is_online, last_seen, subscription_tier, created_at, updated_at,
                   ST_Y(location::geometry) as lat, ST_X(location::geometry) as lon,
                   public_key_x25519
            FROM users
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(row.map(|r| User {
            id: r.id,
            phone_number: r.phone_number,
            password_hash: r.password_hash,
            name: r.name,
            username: r.username,
            bio: r.bio,
            avatar_url: r.avatar_url,
            location: r.lat.and_then(|lat| r.lon.map(|lon| (lat, lon))),
            public_key: r.public_key_x25519,
            is_verified: r.is_verified,
            is_online: r.is_online,
            last_seen: r.last_seen,
            subscription_tier: match r.subscription_tier.as_str() {
                "Monthly" => SubscriptionTier::Monthly,
                "Yearly" => SubscriptionTier::Yearly,
                _ => SubscriptionTier::Free,
            },
            created_at: r.created_at,
            updated_at: r.updated_at,
        }))
    }

    async fn find_by_phone(&self, phone_number: &str) -> DomainResult<Option<User>> {
        let row = sqlx::query!(
            r#"
            SELECT id, phone_number, password_hash, name, username, bio, avatar_url,
                   is_verified, is_online, last_seen, subscription_tier, created_at, updated_at,
                   ST_Y(location::geometry) as lat, ST_X(location::geometry) as lon,
                   public_key_x25519
            FROM users
            WHERE phone_number = $1
            "#,
            phone_number
        )
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(row.map(|r| User {
            id: r.id,
            phone_number: r.phone_number,
            password_hash: r.password_hash,
            name: r.name,
            username: r.username,
            bio: r.bio,
            avatar_url: r.avatar_url,
            location: r.lat.and_then(|lat| r.lon.map(|lon| (lat, lon))),
            public_key: r.public_key_x25519,
            is_verified: r.is_verified,
            is_online: r.is_online,
            last_seen: r.last_seen,
            subscription_tier: match r.subscription_tier.as_str() {
                "Monthly" => SubscriptionTier::Monthly,
                "Yearly" => SubscriptionTier::Yearly,
                _ => SubscriptionTier::Free,
            },
            created_at: r.created_at,
            updated_at: r.updated_at,
        }))
    }

    async fn find_by_username(&self, username: &str) -> DomainResult<Option<User>> {
        let row = sqlx::query!(
            r#"
            SELECT id, phone_number, password_hash, name, username, bio, avatar_url,
                   is_verified, is_online, last_seen, subscription_tier, created_at, updated_at,
                   ST_Y(location::geometry) as lat, ST_X(location::geometry) as lon,
                   public_key_x25519
            FROM users
            WHERE username = $1
            "#,
            username
        )
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(row.map(|r| User {
            id: r.id,
            phone_number: r.phone_number,
            password_hash: r.password_hash,
            name: r.name,
            username: r.username,
            bio: r.bio,
            avatar_url: r.avatar_url,
            location: r.lat.and_then(|lat| r.lon.map(|lon| (lat, lon))),
            public_key: r.public_key_x25519,
            is_verified: r.is_verified,
            is_online: r.is_online,
            last_seen: r.last_seen,
            subscription_tier: match r.subscription_tier.as_str() {
                "Monthly" => SubscriptionTier::Monthly,
                "Yearly" => SubscriptionTier::Yearly,
                _ => SubscriptionTier::Free,
            },
            created_at: r.created_at,
            updated_at: r.updated_at,
        }))
    }

    async fn update(&self, user: &User) -> DomainResult<User> {
        let subscription_tier = match user.subscription_tier {
            SubscriptionTier::Free => "Free",
            SubscriptionTier::Monthly => "Monthly",
            SubscriptionTier::Yearly => "Yearly",
        };

        let row = sqlx::query!(
            r#"
            UPDATE users
            SET name = $2, username = $3, bio = $4, avatar_url = $5, 
                is_verified = $6, subscription_tier = $7, public_key_x25519 = $8
            WHERE id = $1
            RETURNING id, phone_number, password_hash, name, username, bio, avatar_url,
                      is_verified, is_online, last_seen, subscription_tier, created_at, updated_at, public_key_x25519
            "#,
            user.id,
            user.name,
            user.username,
            user.bio,
            user.avatar_url,
            user.is_verified,
            subscription_tier,
            user.public_key
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(User {
            id: row.id,
            phone_number: row.phone_number,
            password_hash: row.password_hash,
            name: row.name,
            username: row.username,
            bio: row.bio,
            avatar_url: row.avatar_url,
            location: None,
            public_key: row.public_key_x25519,
            is_verified: row.is_verified,
            is_online: row.is_online,
            last_seen: row.last_seen,
            subscription_tier: match row.subscription_tier.as_str() {
                "Monthly" => SubscriptionTier::Monthly,
                "Yearly" => SubscriptionTier::Yearly,
                _ => SubscriptionTier::Free,
            },
            created_at: row.created_at,
            updated_at: row.updated_at,
        })
    }

    async fn delete(&self, id: Uuid) -> DomainResult<()> {
        sqlx::query!("DELETE FROM users WHERE id = $1", id)
            .execute(&self.pool)
            .await
            .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }

    async fn find_nearby(&self, lat: f64, lon: f64, radius_km: f64) -> DomainResult<Vec<User>> {
        let radius_meters = radius_km * 1000.0;

        let rows = sqlx::query!(
            r#"
            SELECT id, phone_number, password_hash, name, username, bio, avatar_url,
                   is_verified, is_online, last_seen, subscription_tier, created_at, updated_at,
                   ST_Y(location::geometry) as lat, ST_X(location::geometry) as lon
            FROM users
            WHERE location IS NOT NULL
              AND ST_DWithin(location, ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography, $3)
            "#,
            lon,
            lat,
            radius_meters
        )
        .fetch_all(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(rows
            .into_iter()
            .map(|r| User {
                id: r.id,
                phone_number: r.phone_number,
                password_hash: r.password_hash,
                name: r.name,
                username: r.username,
                bio: r.bio,
                avatar_url: r.avatar_url,
                location: r.lat.and_then(|lat| r.lon.map(|lon| (lat, lon))),
                public_key: r.public_key_x25519,
                is_verified: r.is_verified,
                is_online: r.is_online,
                last_seen: r.last_seen,
                subscription_tier: match r.subscription_tier.as_str() {
                    "Monthly" => SubscriptionTier::Monthly,
                    "Yearly" => SubscriptionTier::Yearly,
                    _ => SubscriptionTier::Free,
                },
                created_at: r.created_at,
                updated_at: r.updated_at,
            })
            .collect())
    }

    async fn update_location(&self, user_id: Uuid, lat: f64, lon: f64) -> DomainResult<()> {
        sqlx::query!(
            r#"
            UPDATE users
            SET location = ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography
            WHERE id = $1
            "#,
            user_id,
            lon,
            lat
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }

    async fn update_online_status(&self, user_id: Uuid, is_online: bool) -> DomainResult<()> {
        sqlx::query!(
            r#"
            UPDATE users
            SET is_online = $2, last_seen = CASE WHEN $2 = false THEN NOW() ELSE last_seen END
            WHERE id = $1
            "#,
            user_id,
            is_online
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }

    async fn update_public_key(&self, user_id: Uuid, public_key: String) -> DomainResult<()> {
        sqlx::query!(
            r#"
            UPDATE users
            SET public_key_x25519 = $2
            WHERE id = $1
            "#,
            user_id,
            public_key
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }
}
