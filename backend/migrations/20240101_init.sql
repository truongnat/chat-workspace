-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name VARCHAR(100),
    username VARCHAR(50) UNIQUE,
    bio TEXT,
    avatar_url TEXT,
    location GEOGRAPHY(POINT),
    is_verified BOOLEAN DEFAULT FALSE,
    is_online BOOLEAN DEFAULT FALSE,
    last_seen TIMESTAMP,
    subscription_tier VARCHAR(20) DEFAULT 'Free' CHECK (subscription_tier IN ('Free', 'Monthly', 'Yearly')),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Create index for phone number lookup
CREATE INDEX idx_users_phone ON users(phone_number);

-- Create spatial index for location queries
CREATE INDEX idx_users_location ON users USING GIST(location);

-- KYC Requests table
CREATE TABLE kyc_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    front_doc_url TEXT NOT NULL,
    back_doc_url TEXT,
    selfie_url TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Reviewing', 'Approved', 'Rejected')),
    admin_note TEXT,
    reviewed_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    reviewed_at TIMESTAMP
);

CREATE INDEX idx_kyc_user ON kyc_requests(user_id);
CREATE INDEX idx_kyc_status ON kyc_requests(status);

-- Conversations table
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) NOT NULL CHECK (type IN ('Private', 'Group')),
    name VARCHAR(100),
    avatar_url TEXT,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Conversation participants
CREATE TABLE conversation_participants (
    conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT NOW(),
    last_read_at TIMESTAMP,
    PRIMARY KEY (conversation_id, user_id)
);

CREATE INDEX idx_participants_user ON conversation_participants(user_id);
CREATE INDEX idx_participants_conversation ON conversation_participants(conversation_id);

-- Messages table
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    type VARCHAR(20) DEFAULT 'Text' CHECK (type IN ('Text', 'Image', 'Video', 'Audio', 'File', 'System', 'CallSignal')),
    is_encrypted BOOLEAN DEFAULT TRUE,
    reply_to_id UUID REFERENCES messages(id),
    self_destruct_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_self_destruct ON messages(self_destruct_at) WHERE self_destruct_at IS NOT NULL;

-- Message reactions
CREATE TABLE message_reactions (
    message_id UUID REFERENCES messages(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    reaction VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (message_id, user_id)
);

-- Message read receipts
CREATE TABLE message_read_receipts (
    message_id UUID REFERENCES messages(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    read_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (message_id, user_id)
);

-- Refresh tokens table
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
