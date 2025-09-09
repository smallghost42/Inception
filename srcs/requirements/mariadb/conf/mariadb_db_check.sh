#!/bin/sh

if [ ! -d "mariadb" ]; then
  mariadb-install-db --user=$USER_NAME --datadir=/app/data

  #skip-networking and --skip-log-bin flags are for security during setup.
  nohup mariadbd --datadir=$DB_DATA_DIR --user=$USER_NAME \
    --skip-networking --skip-log-bin >/dev/null 2>&1 &
  # Store the process ID to kill it later.
  MARIADB_PID=$!
  # Wait for the MariaDB daemon to be ready.
  # We poll the server status until it's accepting connections.
  for i in {30..0}; do
    if mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  if [ $i -eq 0 ]; then
    exit 1
  fi

  mariadb -u root <<EOF
    CREATE DATABASE $DB_NAME;
    
    CREATE USER '$ADMIN_NAME'@'$HOST' IDENTIFIED BY '$ADMIN_PASS_FILE';
    CREATE USER '$USER_NAME'@'$HOST' IDENTIFIED BY '$USER_PASS_FILE';
    
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$ADMIN_NAME'@'$HOST';
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$USER_NAME'@'$HOST';
    
    FLUSH PRIVILEGES;
EOF

  # Step 5: Stop the temporary MariaDB daemon.
  echo "Stopping temporary MariaDB daemon..."
  kill -TERM $MARIADB_PID
  wait $MARIADB_PID
  echo "Setup complete."

else
  echo "MariaDB data directory already exists. Skipping initial setup."
fi

# Step 6: Start the main MariaDB daemon for normal operation.
echo "Starting MariaDB daemon for normal operation."
exec mariadbd --datadir=$DB_DATA_DIR --user=$USER_NAME
