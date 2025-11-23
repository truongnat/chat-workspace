# Docker Setup for Secure Chat App

## Architecture

This Docker Compose setup runs 5 containers:

1. **nginx** (Port 8080): Entry point, serves Flutter web app and proxies API requests
2. **backend** (Port 3000): Rust/Axum API server
3. **frontend_build**: Builds Flutter web assets (exits after build)
4. **db** (Port 5432): PostgreSQL with PostGIS
5. **redis** (Port 6379): Redis for pub/sub

## Quick Start

### 1. Setup Environment Variables

The backend reads configuration from `backend/.env` file. A sample file is already created for Docker:

```bash
# backend/.env is already configured for Docker Compose
# Key settings:
DATABASE_URL=postgresql://chatuser:chatpass@db:5432/chat_db
REDIS_URL=redis://redis:6379
PORT=3000
```

**Important**: The `.env` file uses Docker service names (`db`, `redis`) as hostnames, which only work inside Docker network.

### 2. Start Services

```bash
# Build and start all services
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

## Access Points

- **Web App**: http://localhost:8080
- **API**: http://localhost:8080/api/*
- **WebSocket**: ws://localhost:8080/ws
- **Database**: localhost:5432 (user: chatuser, pass: chatpass, db: chat_db)
- **Redis**: localhost:6379

## Configuration

### Environment Variables

The backend uses `backend/.env` for configuration. Key variables:

**Required**:
- `DATABASE_URL`: PostgreSQL connection (uses `db` hostname in Docker)
- `REDIS_URL`: Redis connection (uses `redis` hostname in Docker)
- `JWT_SECRET`: Secret key for JWT tokens
- `RPC_URL`: Ethereum RPC endpoint

**Optional** (leave empty for mock mode):
- `S3_ENDPOINT`, `S3_BUCKET`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_REGION`: S3 storage
- `FCM_SERVER_KEY`: Firebase Cloud Messaging
- `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_VERIFY_SID`: Twilio OTP

### Running Outside Docker

If you want to run the backend locally (not in Docker):

1. Copy `backend/.env.example` to `backend/.env`
2. Update `DATABASE_URL` to use `localhost` instead of `db`:
   ```bash
   DATABASE_URL=postgresql://chatuser:chatpass@localhost:5432/chat_db
   REDIS_URL=redis://localhost:6379
   ```
3. Start only the database:
   ```bash
   docker-compose up -d db redis
   ```
4. Run backend locally:
   ```bash
   cd backend
   cargo run
   ```

### CORS

CORS is handled by Nginx reverse proxy. No backend code changes needed.

## Development Workflow

1. Make changes to backend/frontend code
2. Rebuild specific service:
   ```bash
   docker-compose up -d --build backend
   # or
   docker-compose up -d --build frontend_build nginx
   ```

## Troubleshooting

### Backend won't start
```bash
# Check logs
docker-compose logs backend

# Common issue: Database not ready
# Solution: Wait for db healthcheck to pass
docker-compose ps

# Check database connection
docker-compose exec db psql -U chatuser -d chat_db
```

### Frontend not updating
```bash
# Rebuild frontend
docker-compose up -d --build frontend_build nginx
```

### Database issues
```bash
# Reset database
docker-compose down -v
docker-compose up -d db
```

### Connection refused errors
- Make sure you're using service names (`db`, `redis`) in `backend/.env`, not `localhost`
- Service names only work inside Docker network

## Production Deployment

For production:
1. Update `JWT_SECRET` to a strong random value
2. Set real `FCM_SERVER_KEY` and Twilio credentials
3. Use proper `DATABASE_URL` (managed PostgreSQL)
4. Configure S3 credentials for file uploads
5. Enable HTTPS in Nginx
6. Set `CORS_ORIGIN` to your domain
7. Use environment-specific `.env` files
