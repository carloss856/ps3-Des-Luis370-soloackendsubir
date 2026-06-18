# Backend Laravel + MongoDB (jenssegers/mongodb) para Render (plan free)
FROM php:8.3-cli

# Dependencias del sistema + extensión MongoDB de PHP
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libssl-dev \
 && docker-php-ext-install zip \
 && pecl install mongodb \
 && docker-php-ext-enable mongodb \
 && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Instalar dependencias de producción
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Permisos de storage/cache
RUN chmod -R 775 storage bootstrap/cache

# Render inyecta $PORT. Servidor PHP embebido con router (estable tras proxy).
EXPOSE 8000
CMD php -d display_errors=1 -d display_startup_errors=1 -d error_reporting=E_ALL -d log_errors=1 -S 0.0.0.0:${PORT:-8000} server.php
