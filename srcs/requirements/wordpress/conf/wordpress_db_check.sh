#!/bin/sh
chmod -R 755 /app/data

DB_PASS=$(cat /run/secrets/db_pass)
ADMIN_PASS=$(cat /run/secrets/credentials2)
USER_PASS=$(cat /run/secrets/credentials)

if [ ! -e wp-load.php ]; then
  echo "install core download"
  wp core download --path="/app/data/"
fi

until nc -z -w 2 mariadb $PORT; do
  echo "Waiting ..."
  sleep 2
done

if [ ! -e wp-config.php ]; then
  wp config create --dbname="$DB_NAME" --dbuser="$ADMIN_NAME" --dbpass="$DB_PASS" --dbhost="$HOST:$PORT" --path="/app/data/"
fi

wp db create --path="/app/data/" || true

if ! wp core is-installed; then
  wp core install --url="$URL" --admin_user="$ADMIN_NAME" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_NAME@exemple.com" --title="$TITLE" --path="/app/data/"
fi
wp user create newuser $USER_NAME@example.com --role="editor" --user_pass="$USER_PASS"

chmod -R 777 /app/data/wp-content/uploads

exec php-fpm83 -FR
