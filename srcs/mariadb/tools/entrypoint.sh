#!/bin/bash
set -e

echo "🟡 [ENTRYPOINT] Script de démarrage lancé"

if [ ! -f /var/lib/mysql/.db_initialized ]; then
  echo "📁 [INIT] Première initialisation de la base"

  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
  echo "✅ [INIT] mysql_install_db terminé"

  mysqld_safe --skip-networking &
  sleep 5

  echo "📥 [INIT] Exécution de init.sql"
  mysql -u root < /docker-entrypoint-initdb.d/init.sql

  mysqladmin -u root shutdown

  # 💾 Création d’un fichier de marqueur pour éviter de réinitialiser
  touch /var/lib/mysql/.db_initialized
else
  echo "📦 [SKIP] Base déjà initialisée"
fi

echo "🚀 [START] Lancement final de MariaDB"
exec mysqld_safe
