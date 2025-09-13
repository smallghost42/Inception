#!/bin/sh

# if wp core version; then
#   echo "already there"
# else
#   php -d memory_limit=512M $(which wp) core download
#   wp core download
#   wp config create --dbname=$DB_NAME --dbuser=$USER_NAME --dbpass=$DB_PASS_FILE --dbhost=$HOST
#   wp db create
#   wp core install --url=$URL --admin_user=$ADMIN_NAME --admin_password=$ADMIN_PASS_FILE
# fi

if [ ! -f wp-load.php ]; then
  wp core download
fi

echo $DB_NAME $DB_PASS_FILE
cat $DB_PASS_FILE

if [ ! -f wp-config.php ]; then
  wp config create --dbname="$DB_NAME" --dbuser="$USER_NAME" --dbpass="$DB_PASS_FILE" --dbhost="$HOST:3306"
fi

wp db create || true

if ! wp core is-installed; then
  wp core install --url="$URL" --admin_user="$ADMIN_NAME" --admin_password="$ADMIN_PASS_FILE"
fi
