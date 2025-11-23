# Secure Social Messaging App

A privacy-focused, feature-rich social messaging application built with a robust Rust backend and a performant Flutter frontend.

## 🚀 Project Status

### Backend (Rust) - **COMPLETE** ✅
The backend is fully implemented, following Clean Architecture principles.

- **Phase 1: Foundation**: Axum, SQLx, Tokio, PostGIS.
- **Phase 2: Auth**: JWT, Argon2, OTP verification.
- **Phase 3: KYC**: Identity verification with S3 presigned URLs.
- **Phase 4: Chat**: Real-time messaging via WebSockets & Redis Pub/Sub.
- **Phase 5: WebRTC**: Signaling server for video/audio calls.
- **Phase 6: Geo-location**: Nearby user discovery using PostGIS spatial queries.
- **Phase 7: Jobs**: Background message cleanup (self-destruct).
- **Phase 8: Subscriptions**: Premium tier management.
- **Phase 9: Hardening**: OTP verification, production readiness.
- **Phase 10: E2EE**: Public key storage and exchange endpoints.
- **Phase 11: Web3**: Non-custodial wallet & Blockchain integration.

### Frontend (Flutter) - **COMPLETE** ✅
The frontend is fully implemented with production-ready features.

- **Networking**: `ApiClient` with Dio interceptors for Auth and automatic logout on 401.
- **Real-time**: `WebSocketService` implementing the strict JSON protocol.
- **Auth**: Complete flow (Login, Register, OTP, getCurrentUser) with JWT token management.
- **Security**: **End-to-End Encryption (E2EE)** using `sodium_libs` (X25519 + XSalsa20-Poly1305).
- **Web3**: Non-custodial wallet with BIP39 mnemonic, PIN protection (SHA256), Send/Receive ETH, QR codes.
- **Chat**: Full API integration (getChats, sendMessage, reactions, delete) - no mock data.
- **State Management**: Riverpod with Clean Architecture (Domain → Data → Presentation).
- **UI**: Comprehensive screens (Auth, Chat, Video Call, Settings, Wallet) with optimized widgets.

## 🛠️ Tech Stack

### Backend
- **Language**: Rust
- **Framework**: Axum
- **Database**: PostgreSQL + PostGIS (Supabase)
- **Real-time**: Redis, Tokio Broadcast
- **Storage**: AWS S3 (Supabase Storage)
- **Blockchain**: Ethers-rs

### Frontend
- **Framework**: Flutter
- **State Management**: Riverpod
- **Networking**: Dio, WebSocketChannel
- **Cryptography**: Libsodium (`sodium_libs`)
- **Web3**: Web3Dart, Bip39, Crypto
- **Local Storage**: Flutter Secure Storage

## 🏃‍♂️ Getting Started

### Option 1: Docker Compose (Recommended for Testing) 🐳

The easiest way to run the entire stack:

```bash
# Start all services (Backend, Frontend, Database, Redis, Nginx)
docker-compose up --build

# Access the app
# Web App: http://localhost:8080
# API: http://localhost:8080/api/*
# WebSocket: ws://localhost:8080/ws
```

**What's included:**
- ✅ PostgreSQL with PostGIS
- ✅ Redis for pub/sub
- ✅ Rust backend (auto-configured)
- ✅ Flutter web build
- ✅ Nginx reverse proxy (handles CORS)

**Configuration:**
- Backend uses `backend/.env` (already configured for Docker)
- All services communicate via Docker network
- No manual setup required!

See [DOCKER.md](DOCKER.md) for detailed instructions.

---

### Option 2: Local Development

#### Backend
1. Navigate to `backend/`.
2. Copy `.env.example` to `.env` and configure:
   ```bash
   DATABASE_URL=postgresql://user:pass@localhost:5432/chat_db
   REDIS_URL=redis://localhost:6379
   JWT_SECRET=your-secret-key
   ```
3. Start dependencies:
   ```bash
   docker-compose up -d db redis
   ```
4. Run backend:
   ```bash
   cargo run
   ```
   - Server listens on `0.0.0.0:8080` (configurable via `PORT` env var).

#### Frontend
1. Navigate to root (Flutter project).
2. Run `flutter pub get`.
3. Run `flutter run` (mobile) or `flutter run -d chrome` (web).
   - Connects to backend at `10.0.2.2:8080` (Android) or `localhost:8080` (iOS/Web).

## 📡 Real-time Protocol
WebSocket messages follow a strict JSON format:
```json
{
  "type": "EVENT_NAME",
  "payload": { ... }
}
```
**Events**: `SendMessage`, `WebRtcSignal`, `SystemEvent`.

## 🔒 Security Architecture
- **End-to-End Encryption**: Messages are encrypted on the device using **X25519** for key exchange and **XSalsa20-Poly1305** for encryption. The backend only stores encrypted blobs and public keys.
- **Secure Storage**: Private keys and auth tokens are stored in the device's secure enclave (Keychain/Keystore) via `flutter_secure_storage`.
- **Zero Knowledge**: The server cannot decrypt user messages.
- **Non-Custodial Wallet**: Private keys are generated on-device (BIP39 mnemonic) and never leave the user's phone. PIN protection uses SHA256 hashing.
- **Auth Security**: JWT tokens with automatic logout on 401. Global auth state management via Riverpod.
- **Input Validation**: Phone numbers, Ethereum addresses, and amounts validated before API calls.

## 🚀 Deployment

### Docker Production
1. Update `docker-compose.yml` with production credentials
2. Set strong `JWT_SECRET`
3. Configure real S3, FCM, and Twilio credentials
4. Enable HTTPS in Nginx
5. Deploy to your cloud provider

### Environment Variables
All services support configuration via environment variables. See:
- `backend/.env.example` for backend config
- `docker-compose.yml` for Docker setup
- `DOCKER.md` for detailed deployment guide

## 📄 License
Proprietary.
