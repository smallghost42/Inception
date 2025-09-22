#!/bin/sh
chmod -R 755 /app/data

DB_PASS=$(cat /run/secrets/db_pass)
ADMIN_PASS=$(cat /run/secrets/credentials2)

if [ ! -e wp-load.php ]; then
  echo "install core download"
  wp core download --path="/app/data/"
fi

if [ ! -e wp-config.php ]; then
  echo "----------------------"
  echo $DB_NAME
  wp config create --dbname="$DB_NAME" --dbuser="$USER_NAME" --dbpass="$DB_PASS" --dbhost="mariadb:3306" --path="/app/data/"
  echo "----------------------"
fi

wp db create --path="/app/data/" || true

if ! wp core is-installed; then
  wp core install --url="$URL" --admin_user="$ADMIN_NAME" --admin_password="$ADMIN_PASS" --path="/app/data/"
fi
