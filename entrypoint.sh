#!/bin/sh
set -e

# Handle Basic Authentication configuration
if [ -n "$HTTP_AUTH_USER" ] && [ -n "$HTTP_AUTH_PASS" ]; then
    echo "[INFO] Enabling HTTP Basic Authentication for user '$HTTP_AUTH_USER'..."
    htpasswd -c -b /etc/nginx/.htpasswd "$HTTP_AUTH_USER" "$HTTP_AUTH_PASS"
    cat <<EOF > /etc/nginx/conf.d/auth.conf
auth_basic "Navicat Tunnel Restricted Area";
auth_basic_user_file /etc/nginx/.htpasswd;
EOF
else
    echo "[INFO] HTTP Basic Authentication disabled."
    rm -f /etc/nginx/conf.d/auth.conf
fi

echo "[INFO] Starting PHP-FPM..."
php-fpm83 -D || php-fpm -D

echo "[INFO] Starting Nginx..."
exec nginx -g 'daemon off;'
