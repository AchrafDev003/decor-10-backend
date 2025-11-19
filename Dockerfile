# Dockerfile para Laravel + FrankenPHP en Railway
FROM dunglas/frankenphp:php8.2.29-bookworm

# Directorio de trabajo
WORKDIR /app

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
