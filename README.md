# PHP Laravel Base Image

Pre-built PHP 8.3 FPM Alpine image with all common Laravel extensions compiled and standard configs baked in.

## Usage

Standard Laravel app — no per-app config files needed:

```dockerfile
FROM ghcr.io/nakatomitrading/docker/laravel-83:latest

COPY . .
RUN cp -n .env.example .env 2>/dev/null || true
RUN composer install --no-dev --optimize-autoloader --no-interaction
RUN php artisan key:generate --force || true
RUN npm install && npm run build
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache
```

The base image handles nginx, supervisor, PHP config, and the entrypoint (migrations + config caching + supervisor start).

## What's Included

**PHP Extensions:**
- gd (with freetype, jpeg)
- pdo_mysql
- pdo_pgsql
- mbstring
- exif
- pcntl
- bcmath
- zip
- intl
- opcache

**Tools:**
- Composer (latest)
- Node.js + npm
- nginx
- supervisor
- git

**Baked-in Configs:**
- **nginx** — Standard Laravel vhost on port 80, 50M body size, static asset caching, security headers
- **PHP** — 256M memory, 50M uploads, opcache enabled
- **supervisor** — PHP-FPM + nginx, logs to stdout/stderr
- **entrypoint** — Runs migrations, caches config/routes/views, starts supervisor

## Overriding Defaults

Apps with non-standard needs can override any config by copying over the default path:

```dockerfile
FROM ghcr.io/nakatomitrading/docker/laravel-83:latest

COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction
RUN npm install && npm run build

# Override just what you need
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/entrypoint.sh /entrypoint.sh
```

Config file paths:
- nginx: `/etc/nginx/http.d/default.conf`
- PHP: `/usr/local/etc/php/conf.d/custom.ini`
- supervisor: `/etc/supervisor/conf.d/supervisord.conf`
- entrypoint: `/entrypoint.sh`

## Tags

- `latest` - Most recent build
- `YYYYMMDD` - Dated builds (e.g., `20260121`)
- `8.3.x-YYYYMMDD` - Full PHP version + date (e.g., `8.3.15-20260121`)

Use dated tags to pin a known-good version.

## Auto-rebuild

This image automatically rebuilds when:
- Code is pushed to main
- The base `php:8.3-fpm-alpine` image is updated (checked weekly)
- Manually triggered via workflow dispatch

The workflow compares the base image digest to avoid unnecessary rebuilds.

## Why?

Compiling PHP extensions on Alpine takes 2-3 minutes. With this base image, app builds drop to ~30 seconds (just composer install + npm build). Baked-in configs mean zero boilerplate per app.
