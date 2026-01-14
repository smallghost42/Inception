#!/bin/bash
set -e

if [ ! -d "/app/data/mysql" ]; then
  echo "Initialize DB"
  mariadb-install-db --user=mysql --datadir=/app/data
fi

# Edit config *before* starting MariaDB
sed -i 's/^!includedir \/etc\/my\.cnf\.d/#&/' /etc/my.cnf
sed -i '/^\[mysqld\]/a bind-address=0.0.0.0' /etc/my.cnf

DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_PASS=$(cat /run/secrets/db_pass)

# Start MariaDB as coprocess (no network for safety)
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
coproc MDB { mariadbd --user=mysql --datadir=/app/data --skip-networking; }

# Check if database exists and set password flag
[ -f "/app/data/ib_logfile0" ] && PASS_FLAG="-p$DB_ROOT_PASS" || PASS_FLAG=""

# Wait until MariaDB is ready
until mariadb -u root $PASS_FLAG -e "SELECT 1;" &>/dev/null; do sleep 2; done

# Set root password on first run
[ -z "$PASS_FLAG" ] && mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"

mariadb -u root -p$DB_ROOT_PASS <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$ADMIN_NAME'@'%' IDENTIFIED BY '$DB_PASS';
ALTER USER '$ADMIN_NAME'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$ADMIN_NAME'@'%';
FLUSH PRIVILEGES;
EOF

mariadb-admin -u root -p$DB_ROOT_PASS shutdown


exec mariadbd --datadir=/app/data --user=mysql --bind-address=0.0.0.0 --port=${DB_PORT}
