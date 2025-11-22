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
- **Phase 9: Hardening**: OTP verification, production readiness (In Progress).
- **Phase 10: E2EE**: Public key storage and exchange endpoints (Complete).

### Frontend (Flutter) - **IN PROGRESS** 🚧
Integration with the backend is well underway, with core security features implemented.

- **Networking**: `ApiClient` with Dio interceptors for Auth.
- **Real-time**: `WebSocketService` implementing the strict JSON protocol.
- **Auth**: Remote data sources and repositories for Login/Register.
- **Security**: **End-to-End Encryption (E2EE)** using `sodium_libs` (X25519 + XSalsa20-Poly1305).
- **UI**: Comprehensive UI library and screens implemented (Auth, Chat, Video Call, Settings).

## 🛠️ Tech Stack

### Backend
- **Language**: Rust
- **Framework**: Axum
- **Database**: PostgreSQL + PostGIS (Supabase)
- **Real-time**: Redis, Tokio Broadcast
- **Storage**: AWS S3 (Supabase Storage)

### Frontend
- **Framework**: Flutter
- **State Management**: Riverpod
- **Networking**: Dio, WebSocketChannel
- **Cryptography**: Libsodium (`sodium_libs`)
- **Local Storage**: Flutter Secure Storage

## 🏃‍♂️ Getting Started

### Backend
1. Navigate to `backend/`.
2. Copy `.env.example` to `.env` and fill in secrets.
3. Run `cargo run`.
   - Server listens on `0.0.0.0:8080`.

### Frontend
1. Navigate to root (Flutter project).
2. Run `flutter pub get`.
3. Run `flutter run`.
   - Connects to backend at `10.0.2.2:8080` (Android) or `localhost:8080` (iOS).

## 📡 Real-time Protocol
WebSocket messages follow a strict JSON format:
```json
{
  "type": "EVENT_NAME",
  "payload": { ... }
}
```
**Events**: `SendMessage`, `WebRtcSignal`, `SystemEvent`.

## � Security Architecture
- **End-to-End Encryption**: Messages are encrypted on the device using **X25519** for key exchange and **XSalsa20-Poly1305** for encryption. The backend only stores encrypted blobs and public keys.
- **Secure Storage**: Private keys and auth tokens are stored in the device's secure enclave (Keychain/Keystore) via `flutter_secure_storage`.
- **Zero Knowledge**: The server cannot decrypt user messages.

## �📄 License
Proprietary.
