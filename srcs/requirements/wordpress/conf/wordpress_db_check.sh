#!/bin/sh

wp core version
if ! [ $? -eq 0 ]; then
  wp core download
  wp config create --dbname=$DB_NAME --dbuser=$USER_NAME --dbpass=$DB_PASS --dbhost=$HOST
  wp db create
  wp core install --url=$URL --admin_user=$ADMIN_NAME --admin_password=$ADMIN_PASS
fi
