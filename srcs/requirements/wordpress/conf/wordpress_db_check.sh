#!/bin/sh
chmod -R 755 /app/data

DB_PASS=$(cat /run/secrets/db_pass)
ADMIN_PASS=$(cat /run/secrets/credentials2)

if [ ! -e wp-load.php ]; then
  echo "install core download"
  wp core download --path="/app/data/"
fi

until nc -z -w 2 mariadb 3306; do
  echo "Waiting for MariaDB to be available..."
  sleep 2
done

if [ ! -e wp-config.php ]; then
  echo $DB_NAME $USER_NAME $DB_PASS
  wp config create --dbname="$DB_NAME" --dbuser="$USER_NAME" --dbpass="$DB_PASS" --dbhost="mariadb:3306" --path="/app/data/"
fi

wp db create --path="/app/data/" || true

if ! wp core is-installed; then
  wp core install \
    --url="$URL" \
    --admin_user="$ADMIN_NAME" \
    --admin_password="$ADMIN_PASS" \
    --admin_email="$ADMIN_EMAIL" \
    --title="$TITLE" \
    --path="/app/data/"
fi

exec php-fpm83 -FR
