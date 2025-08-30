##!/bin/sh
#
#mariadb #check db
#if ! [ $? -eq 0 ]; then
#  mariadb-install-db --user=$USER_NAME --datadir=/app/data
#  mysql -u root -p $DB_ROOT_PASS
#  CREATE DATABASE $DB_NAME
#  CREATE USER $ADMIN_NAME@$HOST IDENTIFIED BY $ADMIN_PASS
#  CREATE USER $USER_NAME@$HOST IDENTIFIED BY $USER_PASS
#  GRANT ALL PRIVILEGES ON $DB_NAME.* TO $ADMIN_NAME@$HOST
#  GRANT ALL PRIVILEGES ON $DB_NAME.* TO $USER_NAME@$HOST
#  FLUSH PRIVILEGES
#fi
#
#rc-service mariadb start
#mariadb-secure-installation
#rc-update add mariadb default

#check db volume if exist if not create new
