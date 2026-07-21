# Navicat HTTP Tunnel Docker Container

[![Build & Publish Docker Image](https://github.com/USERNAME/navicat-tunnel/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/USERNAME/navicat-tunnel/actions)
[![Docker Image Size](https://img.shields.io/docker/image-size/ghcr.io/USERNAME/navicat-tunnel/latest)](https://ghcr.io/USERNAME/navicat-tunnel)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A lightweight, secure, and production-optimized Docker image for hosting the **Navicat PHP HTTP Tunnel** script (`ntunnel_mysql.php`). Built on Alpine Linux with Nginx and PHP 8.3 FPM, designed to allow Navicat database management tools to securely access remote databases through HTTP/HTTPS.

---

## Features

- ⚡ **Lightweight & Fast**: Built on Alpine Linux (~35MB total image size).
- 🛠️ **Database Driver Support**: Includes `mysqli`, `pdo_mysql`, `pgsql`, `pdo_pgsql`, `sqlite3`, and `pdo_sqlite` extensions.
- 🚀 **High Concurrency**: Configured Nginx + PHP-FPM buffer settings optimized for chunked binary data streaming and long-running database operations.
- 🔒 **Built-in Authentication**: Optional HTTP Basic Authentication configurable via environment variables.
- 🌐 **Flexible Endpoint**: Connection works with either `http://<host>/` or `http://<host>/ntunnel_mysql.php`.
- 🌍 **Multi-Architecture**: Supports `linux/amd64` and `linux/arm64` (Apple Silicon / Raspberry Pi).

---

## Quick Start

### Run with Docker

```bash
docker run -d \
  --name navicat-tunnel \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/USERNAME/navicat-tunnel:latest
```

Open `http://localhost:8080/` in your browser to view the **Navicat System Environment Test** interface.

---

## Docker Compose

Save the following as `docker-compose.yml`:

```yaml
version: '3.8'

services:
  navicat-tunnel:
    image: ghcr.io/USERNAME/navicat-tunnel:latest
    container_name: navicat_tunnel
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - ALLOW_TEST_MENU=true
      # Enable Basic Authentication by uncommenting:
      # - HTTP_AUTH_USER=myuser
      # - HTTP_AUTH_PASS=mypassword
```

Start the container:
```bash
docker-compose up -d
```

---

## Environment Variables

| Variable | Default | Description |
| :--- | :--- | :--- |
| `ALLOW_TEST_MENU` | `true` | Set to `false` to disable the browser System/Server test GUI page for security. |
| `HTTP_AUTH_USER` | `""` (disabled) | Username for HTTP Basic Authentication. |
| `HTTP_AUTH_PASS` | `""` (disabled) | Password for HTTP Basic Authentication. |

---

## Navicat Configuration Guide

To connect Navicat to your remote database using this tunnel:

1. Open **Navicat** and edit/create a database connection (e.g. MySQL).
2. Under the **General** tab:
   - **Host**: Enter the database host as accessible *from inside the container or target network* (e.g., `localhost`, `mysql-db`, or internal IP `10.0.0.x`).
   - **Port**: `3306` (or target DB port).
   - **User / Password**: Database credentials.
3. Switch to the **HTTP** tab:
   - Check **Use HTTP Tunnel**.
   - **Tunnel URL**: `http://your-server-ip:8080/` (or `http://your-server-ip:8080/ntunnel_mysql.php`).
   - If Basic Authentication is enabled, check **Use Authentication** under HTTP and enter your `HTTP_AUTH_USER` and `HTTP_AUTH_PASS`.
4. Click **Test Connection**.

---

## Security Best Practices

1. **Enable Basic Authentication**: Set `HTTP_AUTH_USER` and `HTTP_AUTH_PASS` to prevent unauthorized users from accessing the tunnel endpoint.
2. **Disable Test Interface**: Set `ALLOW_TEST_MENU=false` in production so visitors cannot probe database hosts.
3. **Use HTTPS / Reverse Proxy**: Place a reverse proxy (e.g. Cloudflare, Nginx Proxy Manager, Traefik, or Caddy) in front of the container to provide SSL/TLS encryption.

---

## Local Development & Testing

Build the Docker image locally:

```bash
docker build -t navicat-tunnel:local .
```

Run integration test stack with a MySQL server:

```bash
docker-compose -f docker-compose.test.yml up --build
```

---

## License

This Docker container layout is licensed under the [MIT License](LICENSE).
The `ntunnel_mysql.php` script is copyrighted by PremiumSoft CyberTech Ltd.
