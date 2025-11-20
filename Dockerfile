# --------------------------
# Imagen base
# --------------------------
FROM dunglas/frankenphp:php8.3-bookworm

# --------------------------
# Directorio de trabajo
# --------------------------
WORKDIR /app

# --------------------------
# Dependencias del sistema
# --------------------------
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Composer
# --------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# --------------------------
# Copiar proyecto y .env
# --------------------------
COPY . /app
# Asegúrate de que tu .env apunte a la base de datos pública
# DB_HOST=mainline.proxy.rlwy.net
# DB_PORT=45459
# DB_DATABASE=railway
# DB_USERNAME=root
# DB_PASSWORD=HnWrIOcLxOoriiUOSCrQMQFfKFhdsXEb
COPY .env /app/.env

# --------------------------
# Instalar dependencias PHP
# --------------------------
RUN composer install --no-dev --optimize-autoloader

# --------------------------
# Storage y cache
# --------------------------
RUN mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache \
    && chmod -R a+rw storage bootstrap/cache

# --------------------------
# Cache de config, rutas y vistas
# --------------------------
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# --------------------------
# Puerto
# --------------------------
ENV PORT=${PORT:-8080}
EXPOSE $PORT

# --------------------------
# Comando final: ejecutar migraciones y arrancar FrankenPHP
# --------------------------
CMD php artisan migrate --force \
    && frankenphp run public/index.php
