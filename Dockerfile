# 1. Imagen PHP + FPM
FROM php:8.2-fpm

# 2. Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev \
    curl libzip-dev && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# 3. Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Copiar la app
WORKDIR /var/www/html
COPY . .

# 5. Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# 6. Configurar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 7. Instalar Nginx
RUN apt-get install -y nginx

# 8. Copiar configuración Nginx
COPY nginx/default.conf /etc/nginx/sites-available/default

# 9. Exponer puerto
EXPOSE 8080

# 10. Comando para arrancar Nginx + PHP-FPM
CMD service php8.2-fpm start && nginx -g "daemon off;"
