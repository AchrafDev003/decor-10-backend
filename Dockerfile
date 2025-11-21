# -----------------------------
# Imagen base
# -----------------------------
FROM php:8.2-fpm

# -----------------------------
# Instalación de dependencias del sistema y extensiones PHP necesarias
# -----------------------------
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev supervisor \
    libcurl4-openssl-dev libssl-dev zlib1g-dev libicu-dev g++ \
    && docker-php-ext-install \
        pdo_mysql \
        zip \
        mbstring \
        bcmath \
        intl \
        fileinfo \
        opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Instalar Caddy (binario oficial)
# -----------------------------
RUN curl -1sLf 'https://github.com/caddyserver/caddy/releases/latest/download/caddy_2.7.6_linux_amd64.tar.gz' \
    | tar -C /usr/bin -xz caddy \
    && chmod +x /usr/bin/caddy

# -----------------------------
# Configurar directorio de trabajo
# -----------------------------
WORKDIR /var/www/html

# -----------------------------
# Copiar proyecto al contenedor
# -----------------------------
COPY . .

# -----------------------------
# Instalar Composer
# -----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader --prefer-dist --no-interaction

# -----------------------------
# Copiar archivos de configuración
# -----------------------------
COPY Caddyfile /etc/caddy/Caddyfile
COPY docker/supervisor.conf /etc/supervisor/supervisord.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini

# -----------------------------
# Exponer puerto de Railway
# -----------------------------
EXPOSE 8080

# -----------------------------
# Comando por defecto: supervisor
# -----------------------------
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
