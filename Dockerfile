# -----------------------------
# Imagen base
# -----------------------------
FROM php:8.2-fpm

# -----------------------------
# Instalación de dependencias de sistema
# -----------------------------
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev libxml2-dev supervisor \
    && docker-php-ext-install pdo pdo_mysql zip

# -----------------------------
# Instalar Caddy (reemplaza a Nginx)
# -----------------------------
RUN curl -1sLf 'https://get.caddyserver.com/' | bash

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
RUN composer install --no-dev --optimize-autoloader

# -----------------------------
# Copiar archivos de configuración
# -----------------------------
COPY Caddyfile /etc/caddy/Caddyfile
COPY docker/supervisor.conf /etc/supervisor/supervisord.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini

# -----------------------------
# Exponer puerto
# -----------------------------
EXPOSE 8080

# -----------------------------
# Comando por defecto: supervisor
# -----------------------------
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
