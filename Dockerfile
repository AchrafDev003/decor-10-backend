FROM dunglas/frankenphp:php8.3-bookworm

WORKDIR /app

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd \
    && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar proyecto
COPY . /app

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Storage y cache
RUN mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache \
    && chmod -R a+rw storage bootstrap/cache

# Cachear config y rutas (opcional, mejora startup)
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Exponer puerto dinámico de Railway
ENV PORT=${PORT:-8080}
EXPOSE $PORT

# Arrancar FrankenPHP
CMD ["frankenphp", "run", "public/index.php"]
