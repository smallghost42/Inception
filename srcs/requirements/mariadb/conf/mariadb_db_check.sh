#!/bin/bash
set -e

# Initialize the DB if needed
if [ ! -d "/app/data/mysql" ]; then
  echo "Initialize DB"
  mariadb-install-db --user=mysql --datadir=/app/data
fi

# Edit config *before* starting MariaDB
sed -i 's/^!includedir \/etc\/my\.cnf\.d/#&/' /etc/my.cnf
sed -i '/^\[mysqld\]/a bind-address=0.0.0.0' /etc/my.cnf

# Read secrets
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_PASS=$(cat /run/secrets/db_pass)

# Start MariaDB as coprocess (no network for safety)
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
coproc MDB { mariadbd --user=mysql --datadir=/app/data --skip-networking; }

# Wait until MariaDB is ready
until mariadb -u root -e "SELECT 1;" 2>/dev/null; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# Create database and user if needed
DB=$(mariadb -u root -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" | wc -l)

if [ "$DB" -eq 0 ]; then
  mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$USER_NAME'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$USER_NAME'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Shutdown temporary MariaDB
mariadb-admin -u root shutdown

# wait "${MDB_PID}"

# Start MariaDB in the foreground
exec mariadbd --datadir=/app/data --user=mysql
