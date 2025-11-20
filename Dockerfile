# Etapa 1: construir dependencias de Composer
FROM php:8.3-cli as builder

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev \
    && docker-php-ext-install zip pdo pdo_mysql gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-dev --optimize-autoloader

# Etapa 2: Runtime con FrankPHP
FROM dunglas/frankenphp

WORKDIR /app

COPY . .
COPY --from=builder /app/vendor ./vendor

ENV APP_ENV=production
ENV FRANKENPHP_CONFIG="worker ./public/index.php"

EXPOSE 8080

CMD ["php", "vendor/bin/frankenphp", "run", "--config", "/app/frankenphp.json"]
