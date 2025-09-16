#!/bin/sh

if [ ! -d "/app/data/mysql" ]; then
  mariadb-install-db --user=mysql --datadir=/app/data
fi

mariadbd-safe --datadir=/app/data
sleep 5

DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_PASS=$(cat /run/secrets/credentials)

DB=$(mariadb -u root -p"$DB_ROOT_PASS" -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" | wc -l)
sed -i 's/^[[:space:]]*#[[:space:]]*\(bind-address[[:space:]]*=.*\)/\1/' /etc/my.cnf.d/mariadb-server.cnf

if [ "$DB" -eq 0 ]; then
  mariadb -u root -p"$DB_ROOT_PASS" <<EOF
  CREATE DATABASE $DB_NAME;
  CREATE USER '$USER_NAME'@'$HOST' IDENTIFIED BY '$DB_PASS';
  GRANT ALL PRIVILEGES ON *.* TO '$USER_NAME'@'%' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
EOF
fi

mysqladmin -u root -p"$DB_ROOT_PASS" shutdown
