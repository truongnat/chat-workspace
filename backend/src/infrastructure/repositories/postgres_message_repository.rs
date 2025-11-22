use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;

use crate::domain::{
    entities::{Message, MessageType},
    repositories::MessageRepository,
    DomainError, DomainResult,
};

pub struct PostgresMessageRepository {
    pool: PgPool,
}

impl PostgresMessageRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl MessageRepository for PostgresMessageRepository {
    async fn create(&self, message: &Message) -> DomainResult<Message> {
        let message_type = match message.message_type {
            MessageType::Text => "Text",
            MessageType::Image => "Image",
            MessageType::Video => "Video",
            MessageType::Audio => "Audio",
            MessageType::File => "File",
            MessageType::System => "System",
            MessageType::CallSignal => "CallSignal",
        };

        let row = sqlx::query!(
            r#"
            INSERT INTO messages (id, conversation_id, sender_id, content, type, is_encrypted, reply_to_id, self_destruct_at, created_at, is_deleted)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            RETURNING id, conversation_id, sender_id, content, type, is_encrypted, reply_to_id, self_destruct_at, created_at, is_deleted
            "#,
            message.id,
            message.conversation_id,
            message.sender_id,
            message.content,
            message_type,
            message.is_encrypted,
            message.reply_to_id,
            message.self_destruct_at,
            message.created_at,
            message.is_deleted
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(Message {
            id: row.id,
            conversation_id: row.conversation_id,
            sender_id: row.sender_id,
            content: row.content,
            message_type: match row.type_.as_deref() {
                Some("Image") => MessageType::Image,
                Some("Video") => MessageType::Video,
                Some("Audio") => MessageType::Audio,
                Some("File") => MessageType::File,
                Some("System") => MessageType::System,
                Some("CallSignal") => MessageType::CallSignal,
                _ => MessageType::Text,
            },
            is_encrypted: row.is_encrypted.unwrap_or(true),
            reply_to_id: row.reply_to_id,
            self_destruct_at: row.self_destruct_at,
            created_at: row.created_at,
            is_deleted: row.is_deleted.unwrap_or(false),
        })
    }

    async fn find_by_id(&self, id: Uuid) -> DomainResult<Option<Message>> {
        let row = sqlx::query!(
            r#"
            SELECT id, conversation_id, sender_id, content, type, is_encrypted, reply_to_id, self_destruct_at, created_at, is_deleted
            FROM messages
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(row.map(|r| Message {
            id: r.id,
            conversation_id: r.conversation_id,
            sender_id: r.sender_id,
            content: r.content,
            message_type: match r.type_.as_deref() {
                Some("Image") => MessageType::Image,
                Some("Video") => MessageType::Video,
                Some("Audio") => MessageType::Audio,
                Some("File") => MessageType::File,
                Some("System") => MessageType::System,
                Some("CallSignal") => MessageType::CallSignal,
                _ => MessageType::Text,
            },
            is_encrypted: r.is_encrypted.unwrap_or(true),
            reply_to_id: r.reply_to_id,
            self_destruct_at: r.self_destruct_at,
            created_at: r.created_at,
            is_deleted: r.is_deleted.unwrap_or(false),
        }))
    }

    async fn find_by_conversation(
        &self,
        conversation_id: Uuid,
        limit: i64,
        offset: i64,
    ) -> DomainResult<Vec<Message>> {
        let rows = sqlx::query!(
            r#"
            SELECT id, conversation_id, sender_id, content, type, is_encrypted, reply_to_id, self_destruct_at, created_at, is_deleted
            FROM messages
            WHERE conversation_id = $1 AND (is_deleted = false OR is_deleted IS NULL)
            ORDER BY created_at DESC
            LIMIT $2 OFFSET $3
            "#,
            conversation_id,
            limit,
            offset
        )
        .fetch_all(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(rows
            .into_iter()
            .map(|r| Message {
                id: r.id,
                conversation_id: r.conversation_id,
                sender_id: r.sender_id,
                content: r.content,
                message_type: match r.type_.as_deref() {
                    Some("Image") => MessageType::Image,
                    Some("Video") => MessageType::Video,
                    Some("Audio") => MessageType::Audio,
                    Some("File") => MessageType::File,
                    Some("System") => MessageType::System,
                    Some("CallSignal") => MessageType::CallSignal,
                    _ => MessageType::Text,
                },
                is_encrypted: r.is_encrypted.unwrap_or(true),
                reply_to_id: r.reply_to_id,
                self_destruct_at: r.self_destruct_at,
                created_at: r.created_at,
                is_deleted: r.is_deleted.unwrap_or(false),
            })
            .collect())
    }

    async fn update(&self, message: &Message) -> DomainResult<Message> {
        let message_type = match message.message_type {
            MessageType::Text => "Text",
            MessageType::Image => "Image",
            MessageType::Video => "Video",
            MessageType::Audio => "Audio",
            MessageType::File => "File",
            MessageType::System => "System",
            MessageType::CallSignal => "CallSignal",
        };

        let row = sqlx::query!(
            r#"
            UPDATE messages
            SET content = $2, type = $3, is_encrypted = $4, is_deleted = $5
            WHERE id = $1
            RETURNING id, conversation_id, sender_id, content, type, is_encrypted, reply_to_id, self_destruct_at, created_at, is_deleted
            "#,
            message.id,
            message.content,
            message_type,
            message.is_encrypted,
            message.is_deleted
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(Message {
            id: row.id,
            conversation_id: row.conversation_id,
            sender_id: row.sender_id,
            content: row.content,
            message_type: match row.type_.as_deref() {
                Some("Image") => MessageType::Image,
                Some("Video") => MessageType::Video,
                Some("Audio") => MessageType::Audio,
                Some("File") => MessageType::File,
                Some("System") => MessageType::System,
                Some("CallSignal") => MessageType::CallSignal,
                _ => MessageType::Text,
            },
            is_encrypted: row.is_encrypted.unwrap_or(true),
            reply_to_id: row.reply_to_id,
            self_destruct_at: row.self_destruct_at,
            created_at: row.created_at,
            is_deleted: row.is_deleted.unwrap_or(false),
        })
    }

    async fn delete(&self, id: Uuid) -> DomainResult<()> {
        sqlx::query!(
            r#"
            UPDATE messages SET is_deleted = true, content = '' WHERE id = $1
            "#,
            id
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }

    async fn delete_expired(&self) -> DomainResult<u64> {
        let result = sqlx::query!(
            r#"
            DELETE FROM messages WHERE self_destruct_at < NOW()
            "#
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(result.rows_affected())
    }

    async fn mark_as_read(&self, message_id: Uuid, user_id: Uuid) -> DomainResult<()> {
        sqlx::query!(
            r#"
            INSERT INTO message_read_receipts (message_id, user_id, read_at)
            VALUES ($1, $2, NOW())
            ON CONFLICT (message_id, user_id) DO NOTHING
            "#,
            message_id,
            user_id
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }

    async fn add_reaction(&self, message_id: Uuid, user_id: Uuid, reaction: &str) -> DomainResult<()> {
        sqlx::query!(
            r#"
            INSERT INTO message_reactions (message_id, user_id, reaction, created_at)
            VALUES ($1, $2, $3, NOW())
            ON CONFLICT (message_id, user_id) DO UPDATE SET reaction = $3
            "#,
            message_id,
            user_id,
            reaction
        )
        .execute(&self.pool)
        .await
        .map_err(|e| DomainError::InternalError(format!("Database error: {}", e)))?;

        Ok(())
    }
}
