#!/bin/sh
chmod -R 755 /app/data

DB_PASS=$(cat /run/secrets/db_pass)
ADMIN_PASS=$(cat /run/secrets/credentials2)
USER_PASS=$(cat /run/secrets/credentials)
DB_PORT=${DB_PORT:-3306}

# Build URL with port if it's not 443
if [ "${EXPOSED_PORT}" -ne 443 ]; then
  FULL_URL="https://$URL:$EXPOSED_PORT"
else
  FULL_URL="https://$URL"
fi

if [ ! -e wp-load.php ]; then
  wp core download --path="/app/data/"
fi

if [ ! -e wp-config.php ]; then
  wp config create --dbname="$DB_NAME" --dbuser="$ADMIN_NAME" --dbpass="$DB_PASS" --dbhost="mariadb:$DB_PORT" --path="/app/data/"
fi

wp db create --path="/app/data/" || true

if ! wp core is-installed; then
  wp core install --url="$FULL_URL" --admin_user="$ADMIN_NAME" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_NAME@exemple.com" --title="$TITLE" --path="/app/data/"
else
  wp option update home "$FULL_URL" --path="/app/data/" || true
  wp option update siteurl "$FULL_URL" --path="/app/data/" || true
fi

wp user create newuser $USER_NAME@example.com --role="editor" --user_pass="$USER_PASS" || true

chmod -R 777 /app/data/wp-content/uploads

sed -i "s|^listen = .*|listen = 0.0.0.0:${WP_PORT}|" /etc/php83/php-fpm.d/www.conf

exec php-fpm83 -FR