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

# Crear directorios de runtime (el .dockerignore excluye su contenido, así que
# no existen tras COPY -> el driver 'file' de sesión/cache fallaría con 500).
RUN mkdir -p storage/framework/sessions storage/framework/views \
        storage/framework/cache/data storage/logs \
 && chmod -R 775 storage bootstrap/cache

# API stateless con auth por token: evitar drivers que toquen disco/BD.
# (Render puede sobreescribir estas vars desde el dashboard si hace falta.)
ENV SESSION_DRIVER=cookie \
    CACHE_STORE=array \
    QUEUE_CONNECTION=sync

# Render inyecta $PORT. Servidor PHP embebido con router (estable tras proxy).
EXPOSE 8000
CMD php -d display_errors=0 -d log_errors=1 -S 0.0.0.0:${PORT:-8000} server.php
