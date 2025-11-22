-- Add public_key_x25519 to users table
ALTER TABLE users ADD COLUMN public_key_x25519 TEXT UNIQUE;
