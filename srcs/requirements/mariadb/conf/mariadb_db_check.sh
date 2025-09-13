#!/bin/sh

if [ ! -d "/app/data/mysql" ]; then
  mariadb-install-db --user=mysql --datadir=/app/data
fi

mysqld_safe --datadir=/app/data
sleep 5

DB=$(mariadb -u root -p"$DB_ROOT_PASS_FILE" -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" | wc -l)

if [ "$DB" -eq 0 ]; then
  mariadb -u root -p"$DB_ROOT_PASS_FILE" <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$USER_NAME'@'$HOST' IDENTIFIED BY '$USER_PASS';
GRANT ALL PRIVILEGES ON *.* TO '$USER_NAME'@'$HOST' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
fi

mysqladmin -u root -p"$DB_ROOT_PASS_FILE" shutdown
