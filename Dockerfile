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

# Dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Storage y cache
RUN mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache \
    && chmod -R a+rw storage bootstrap/cache

# Puerto dinámico
ENV PORT=${PORT:-8080}
EXPOSE $PORT

# Comando correcto
CMD ["sh", "-c", "frankenphp run public/index.php --port=$PORT"]
