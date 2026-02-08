FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    postgresql-dev \
    libpq \
    nodejs \
    npm \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo_mysql \
        pdo_pgsql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        zip \
        intl \
        opcache

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Bake in standard Laravel configs
COPY config/nginx.conf /etc/nginx/http.d/default.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default working directory for Laravel apps
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

# Labels for image metadata
LABEL org.opencontainers.image.source="https://github.com/nakatomitrading/docker-php-base"
LABEL org.opencontainers.image.description="PHP 8.3 FPM Alpine base image with common Laravel extensions"
LABEL org.opencontainers.image.licenses="MIT"
