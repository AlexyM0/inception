#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "📁 Initialisation de la base de données..."

  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  # Démarrage temporaire de MariaDB sans réseau
  mysqld_safe --skip-networking &
  sleep 5

  echo "📥 Exécution de init.sql"
  mysql -u root < /docker-entrypoint-initdb.d/init.sql

  mysqladmin -u root shutdown
fi

echo "🚀 Lancement de MariaDB..."
exec mysqld_safe
