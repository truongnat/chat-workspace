# Build stage - Use Rust 1.83 (latest stable)
FROM rust:1.83 as builder

WORKDIR /app

# Copy manifests AND Cargo.lock
COPY Cargo.toml Cargo.lock ./

# Copy source code
COPY src ./src

# Build for release
RUN cargo build --release

# Runtime stage
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/target/release/secure-chat-backend /app/backend

# Expose port
EXPOSE 3000

# Run the binary
CMD ["./backend"]
