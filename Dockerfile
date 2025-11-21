# -----------------------------
# Imagen base
# -----------------------------
FROM php:8.2-fpm

# -----------------------------
# Instalación de dependencias de sistema
# -----------------------------
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev libxml2-dev gnupg dirmngr supervisor \
    && docker-php-ext-install pdo pdo_mysql zip

# -----------------------------
# Instalar Caddy (reemplaza a Nginx)
# -----------------------------
RUN apt-get install -y debian-keyring debian-archive-keyring \
 && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
 && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
      | sed 's/^deb /deb [signed-by=\/usr\/share\/keyrings\/caddy-stable-archive-keyring.gpg] /' \
      > /etc/apt/sources.list.d/caddy-stable.list \
 && apt-get update \
 && apt-get install -y caddy

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

# -----------------------------
# Exponer puerto
# -----------------------------
EXPOSE 8080

# -----------------------------
# Comando por defecto: supervisor
# -----------------------------
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
