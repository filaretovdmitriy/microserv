#!/bin/sh
set -e
cd /var/www/html

# Первый запуск: создаём .env, нужные директории и SQLite-файл
[ -f .env ] || cp .env.example .env
mkdir -p storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs bootstrap/cache database
[ -f database/database.sqlite ] || touch database/database.sqlite

# Зависимости устанавливаются в смонтированную папку (vendor/ на Mac)
if [ ! -f vendor/autoload.php ]; then
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

# Ключ приложения
if ! grep -q '^APP_KEY=base64:' .env; then
    php artisan key:generate --force
fi

chown -R www-data:www-data storage bootstrap/cache database

exec "$@"
