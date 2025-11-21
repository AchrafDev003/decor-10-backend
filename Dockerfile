FROM php:8.2-fpm

# Instalación de dependencias
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Instalar Caddy (reemplaza a nginx)
RUN apt-get install -y debian-keyring debian-archive-keyring && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    apt-get update && apt-get install -y caddy

WORKDIR /var/www/html

# Copiar proyecto
COPY . .

# Instalar composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Copiar Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Exponer puerto
EXPOSE 8080

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
