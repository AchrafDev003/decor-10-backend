<<<<<<< HEAD
# Etapa 1: construir dependencias de Composer
FROM php:8.3-cli as builder

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev \
    && docker-php-ext-install zip pdo pdo_mysql gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
=======
# Dockerfile para Laravel + FrankenPHP en Railway
FROM dunglas/frankenphp:php8.2.29-bookworm
>>>>>>> 685fab4a469d11d598d88a5d2380445f3042abe6

# Directorio de trabajo
WORKDIR /app
<<<<<<< HEAD
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
=======

# Copiar los archivos del proyecto
COPY . /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensión zip de PHP
RUN docker-php-ext-install zip

# Instalar Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Instalar dependencias de PHP del proyecto
RUN composer install --no-dev --optimize-autoloader

# Instalar dependencias de Node (si usas Laravel Mix o Vite)
RUN npm ci

# Crear carpetas de storage y cache necesarias para Laravel
RUN mkdir -p storage/framework/{sessions,views,cache,testing} storage/logs bootstrap/cache \
    && chmod -R a+rw storage bootstrap/cache

# Exponer puerto 8000 (el que usará 
ENV PORT=8080
CMD ["sh", "-c", "frankenphp serve --docroot=/app/public --port=$PORT"]

# Comando para ini
>>>>>>> 685fab4a469d11d598d88a5d2380445f3042abe6
