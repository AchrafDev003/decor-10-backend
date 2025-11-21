#!/bin/sh
# entrypoint.sh

# Ejecuta migraciones y cache de Laravel (opcional)
php artisan migrate --force
php artisan config:cache
php artisan route:cache

# Inicia supervisor
exec supervisord -c /etc/supervisor/supervisord.conf
