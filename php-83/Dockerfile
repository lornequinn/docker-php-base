FROM php:8.3-fpm-alpine

RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    postgresql-dev \
    libpq \
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

LABEL org.opencontainers.image.source="https://github.com/lornequinn/docker-php-base"
LABEL org.opencontainers.image.description="PHP 8.3 FPM Alpine with compiled Laravel extensions"
LABEL org.opencontainers.image.licenses="MIT"
