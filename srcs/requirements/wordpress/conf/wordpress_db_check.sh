#!/bin/sh

wp core version
if ! [ $? -eq 0 ]; then
  wp core download
  wp config create --dbname=wp_inceptiondb --dbuser=ferafano --dbpass=small --dbhost=localhost
  wp db create
  wp core install --url=ferafano.42.fr --admin_user=ferafano --admin_password=small
fi
