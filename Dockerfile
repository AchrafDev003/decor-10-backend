FROM dunglas/frankenphp:php8.2.29-bookworm

WORKDIR /app
COPY . /app

# Instalar dependencias
RUN composer install --no-dev --optimize-autoloader
RUN npm ci

# Crear carpetas necesarias y permisos
RUN mkdir -p storage/framework/{sessions,views,cache,testing} storage/logs bootstrap/cache
RUN chmod -R a+rw storage

# Arrancar FrankenPHP
CMD ["frankenphp", "run", "--config", "Caddyfile"]
