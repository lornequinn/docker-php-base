FROM ghcr.io/lornequinn/docker/php-83:latest

RUN apk add --no-cache \
    nginx \
    supervisor \
    nodejs \
    npm

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY config/nginx.conf /etc/nginx/http.d/default.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/lornequinn/docker-php-base"
LABEL org.opencontainers.image.description="Laravel-ready PHP 8.3 with nginx, supervisor, and composer"
LABEL org.opencontainers.image.licenses="MIT"
