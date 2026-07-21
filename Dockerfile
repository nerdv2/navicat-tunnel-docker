FROM alpine:3.20

LABEL maintainer="Navicat Tunnel Maintainer"
LABEL description="Lightweight Docker image for Navicat HTTP Tunnel PHP script"

# Install PHP 8.3, PHP-FPM, database extensions, Nginx, and required utilities
RUN apk add --no-cache \
    curl \
    nginx \
    apache2-utils \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-pdo_mysql \
    php83-pgsql \
    php83-pdo_pgsql \
    php83-sqlite3 \
    php83-pdo_sqlite \
    php83-session \
    php83-json \
    php83-mbstring \
    php83-openssl \
    php83-zlib \
    php83-curl \
    && rm -rf /var/cache/apk/*

# Symlink php-fpm executable if needed
RUN ln -sf /usr/sbin/php-fpm83 /usr/sbin/php-fpm

# Configure Nginx & PHP
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-custom.ini /etc/php83/conf.d/99-custom.ini

# Set up application directory
WORKDIR /var/www/html
COPY index.php ntunnel_mysql.php /var/www/html/

# Set proper file permissions
RUN chown -R nginx:nginx /var/www/html && \
    mkdir -p /run/nginx /etc/nginx/conf.d && \
    chown -R nginx:nginx /run/nginx

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80 for HTTP connections
EXPOSE 80

# Environment variables
ENV ALLOW_TEST_MENU=true
ENV HTTP_AUTH_USER=""
ENV HTTP_AUTH_PASS=""

# Healthcheck to verify Nginx and PHP responsiveness
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
