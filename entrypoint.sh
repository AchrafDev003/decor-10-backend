#!/bin/sh
set -e

# Ejecutar migraciones y caches de Laravel
php artisan migrate --force
php artisan config:cache
php artisan route:cache

# Iniciar Supervisor (PHP-FPM + Caddy)
exec supervisord -c /etc/supervisor/supervisord.conf
