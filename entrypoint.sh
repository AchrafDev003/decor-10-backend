#!/bin/bash
# Ejecutar migraciones y cache de Laravel
php artisan migrate --force
php artisan config:cache
php artisan route:cache

# Arrancar supervisord
exec supervisord -c /etc/supervisor/supervisord.conf
