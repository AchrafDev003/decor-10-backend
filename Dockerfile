FROM php:8.2-fpm

# Extensiones necesarias
RUN apt-get update && apt-get install -y \
    zip unzip git curl nginx supervisor libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Copiar proyecto
WORKDIR /var/www/html
COPY . .

# Instalar dependencias
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Permisos de storage y cache
RUN chmod -R 775 storage bootstrap/cache

# Copiar configuración de Nginx y Supervisor
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Exponer puerto
EXPOSE 8080

CMD ["/usr/bin/supervisord"]

