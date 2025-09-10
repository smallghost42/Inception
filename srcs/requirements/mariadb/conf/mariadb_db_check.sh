#!/bin/sh

ls $DB_NAME
if [ $? -eq 0 ]; then
  mariadb -u root -p $DB_ROOT_PASS_FILE <<EOF
    CREATE DATABASE $DB_NAME; 
    CREATE USER '$USER_NAME'@'$HOST' IDENTIFIED BY '$USER_PASS_FILE';
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$USER_NAME'@'$HOST'; 
    FLUSH PRIVILEGES;
EOF
  mariadb-install-db --user=$USER_NAME --datadir=/app/data
fi
