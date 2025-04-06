#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "⏳ Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo "🚀 Starting MariaDB..."
exec mysqld_safe --skip-networking &
sleep 5

echo "🔑 Setting root password..."
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "🛑 Shutting down MariaDB..."
mysqladmin -u root -p"${MYSQL_PASSWORD}" shutdown

exec mysqld_safe