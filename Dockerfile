# Backend Laravel + MongoDB (jenssegers/mongodb) para Render (plan free)
FROM php:8.3-cli

# Dependencias del sistema + extensión MongoDB de PHP
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libssl-dev ca-certificates openssl pkg-config libcurl4-openssl-dev \
 && update-ca-certificates \
 && docker-php-ext-install zip \
 && pecl install mongodb-2.1.4 \
 && docker-php-ext-enable mongodb \
 && php --ri mongodb | grep -i ssl \
 && rm -rf /var/lib/apt/lists/*

# Forzar preferencia IPv4 (Render egresa IPv6; el allowlist de Atlas es IPv4 → si va por IPv6, Atlas cierra)
RUN printf 'precedence ::ffff:0:0/96 100\n' >> /etc/gai.conf

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
CMD php -d display_errors=0 -d log_errors=1 -S 0.0.0.0:${PORT:-8000} server.php
