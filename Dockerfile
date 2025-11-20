# Imagen oficial de FrankenPHP + PHP 8.3 (optimizada para Laravel)
FROM dunglas/frankenphp:php8.3-bookworm

# Directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema necesarias para Laravel
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd \
    && rm -rf /var/lib/apt/lists/*

# Copiar composer desde la imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar proyecto
COPY . /app

# Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# Crear carpetas necesarias
RUN mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache \
    && chmod -R a+rw storage bootstrap/cache

# Puerto interno de FrankenPHP
ENV PORT=8080

# Configuración de FrankenPHP
ENV FRANKENPHP_CONFIG="worker /app/public/index.php"

# Exponer puerto (Railway usará PORT)
EXPOSE 8080

# Comando correcto para iniciar FrankenPHP
# YA NO usar vendor/bin/frankenphp porque NO existe
CMD ["frankenphp", "run", "--config", "/app"]
