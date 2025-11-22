# Supabase Setup Guide

## 1. Create Supabase Project

1. Go to [https://app.supabase.com](https://app.supabase.com)
2. Click "New Project"
3. Fill in:
   - **Name**: secure-chat-backend
   - **Database Password**: (save this!)
   - **Region**: Choose closest to your users
4. Click "Create new project"

## 2. Get Connection String

1. Go to **Settings** → **Database**
2. Scroll to **Connection string**
3. Select **Connection pooling** (recommended for serverless)
4. Copy the connection string:
   ```
   postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
   ```
5. Replace `[YOUR-PASSWORD]` with your database password

## 3. Enable PostGIS Extension

PostGIS is already available in Supabase! Just enable it:

1. Go to **Database** → **Extensions**
2. Search for "postgis"
3. Click **Enable** on `postgis`

Or run this SQL in the SQL Editor:
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

## 4. Run Migrations

1. Update your `.env` file with the Supabase connection string
2. Run migrations:
   ```bash
   cd backend
   sqlx migrate run
   ```

## 5. Get API Keys

1. Go to **Settings** → **API**
2. Copy these values:
   - **Project URL**: `https://[PROJECT-REF].supabase.co`
   - **anon/public key**: For client-side access
   - **service_role key**: For server-side access (keep secret!)

## 6. Update .env File

```bash
# Database (from step 2)
DATABASE_URL=postgresql://postgres.xxxxx:your-password@aws-0-us-east-1.pooler.supabase.com:6543/postgres

# Supabase (from step 5)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# For Supabase Storage (instead of S3)
S3_ENDPOINT=https://xxxxx.supabase.co/storage/v1
S3_BUCKET=chat-uploads
S3_ACCESS_KEY=your-supabase-service-role-key
S3_SECRET_KEY=your-supabase-service-role-key
```

## 7. Create Storage Bucket (for file uploads)

1. Go to **Storage**
2. Click **New bucket**
3. Name: `chat-uploads`
4. Make it **Private** (we'll handle auth in code)
5. Click **Create bucket**

## 8. Test Connection

```bash
cd backend
cargo run
```

You should see:
```
Database connected
Server listening on 0.0.0.0:8080
```

## Benefits of Supabase

✅ **PostGIS Pre-installed**: No need to install extensions
✅ **Connection Pooling**: Built-in PgBouncer for serverless
✅ **Automatic Backups**: Daily backups included
✅ **Dashboard**: Visual database management
✅ **Storage**: Built-in S3-compatible storage
✅ **Free Tier**: 500MB database, 1GB storage
✅ **SSL**: Automatic SSL connections

## Connection String Formats

### Pooled (Recommended for Serverless)
```
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
```
- Port: 6543
- Uses PgBouncer
- Better for serverless/edge functions

### Direct (For long-running connections)
```
postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
```
- Port: 5432
- Direct connection
- Better for traditional servers

## Troubleshooting

### Connection timeout
- Check if your IP is allowed (Supabase allows all by default)
- Verify password is correct
- Try direct connection instead of pooled

### PostGIS not working
```sql
-- Check if PostGIS is enabled
SELECT PostGIS_version();

-- Enable if not
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Migration fails
- Ensure you're using the correct connection string
- Check if tables already exist
- Verify PostGIS is enabled first
