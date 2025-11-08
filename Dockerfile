# Dockerfile
FROM ubuntu:24.04

WORKDIR /app

# Install dependencies for running ManagerServer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget ca-certificates libicu-dev && \
    rm -rf /var/lib/apt/lists/*

# Download the latest ManagerServer binary
RUN wget -q https://github.com/Manager-io/Manager/releases/latest/download/ManagerServer-linux-x64.tar.gz -O /tmp/ManagerServer.tar.gz && \
    tar -xzf /tmp/ManagerServer.tar.gz -C /app && \
    rm /tmp/ManagerServer.tar.gz && \
    chmod +x /app/ManagerServer

# Default data directory
VOLUME ["/data"]

# Expose HTTP port
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD curl -fs http://localhost:8080 || exit 1

# Start the Manager server
ENTRYPOINT ["./ManagerServer"]
CMD ["--urls", "http://*:8080", "--path", "/data"]
