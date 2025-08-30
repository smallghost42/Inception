#!/bin/sh

mariadb
if ! [ $? -eq 0 ]; then
  mariadb-install-db --user=ferafano --datadir=/app/data
  mysql -u root -p ""
  CREATE DATABASE wp_inception
  CREATE USER 'ferafano' IDENTIFIED BY 'Admin_pass'
  CREATE USER 'small' IDENTIFIED BY 'User_pass'
  GRANT ALL PRIVILEGES ON wp_inception.* TO 'ferafano'@'localhost'
  FLUSH PRIVILEGES
fi

rc-service mariadb start
mariadb-secure-installation
rc-update add mariadb default
