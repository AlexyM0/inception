#!/bin/bash
set -e

# Dossier vide → MariaDB jamais initialisé
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "⏳ Initialisation de la base de données..."

  # Initialiser la base
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  # Lancer mysqld temporairement en background
  mysqld_safe --skip-networking &
  sleep 5

  # Exécuter le fichier SQL
  if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    echo "📥 Exécution du fichier init.sql..."
    mysql -u root < /docker-entrypoint-initdb.d/init.sql
  fi

  # Stop mysqld temporaire
  mysqladmin -u root shutdown
fi

echo "🚀 Lancement de MariaDB..."
exec mysqld_safe