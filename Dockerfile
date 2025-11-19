FROM dunglas/frankenphp:php8.2.29-bookworm

WORKDIR /app
COPY . /app

# Instalar Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Instalar Node.js y npm (si los necesitas)
RUN apt-get update && apt-get install -y nodejs npm

# Instalar dependencias JS
RUN npm ci

# Crear carpetas necesarias y permisos
RUN mkdir -p storage/framework/{sessions,views,cache,testing} storage/logs bootstrap/cache
RUN chmod -R a+rw storage

# Arrancar FrankenPHP
CMD ["frankenphp", "run", "--config", "Caddyfile"]
