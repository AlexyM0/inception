#!/bin/bash
set -e

echo "📂 Dossier courant : $(pwd)"
echo "💬 Commande CMD reçue : $@"

cd /var/www/html

# Ne faire l'installation que si wp-config.php n'existe pas
if [ ! -f wp-config.php ]; then
  echo "🧹 Dossier vidé"
  rm -rf ./*

  # Installer WP-CLI s'il n'existe pas
  if ! command -v wp &> /dev/null; then
    echo "📦 Téléchargement de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
  fi

  echo "🔁 Test MariaDB"
  until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    echo "⏳ En attente de MariaDB..."
    sleep 2
  done

  echo "📥 Téléchargement de WordPress..."
  wp core download --allow-root

  echo "⚙️ Configuration de wp-config.php..."
  sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
  sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
  sed -i "s/localhost/mariadb:3306/g" wp-config-sample.php
  sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
  cp wp-config-sample.php wp-config.php

  echo "🛠 Installation de WordPress..."
  wp core install --url="https://almichel.42.fr" \
    --title="Mon Super Blog" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_MAIL" \
    --skip-email --allow-root

  echo "👤 Création d’un utilisateur secondaire..."
  wp user get "$USER_USER" --allow-root || \
  wp user create "$USER_USER" "$USER_MAIL" \
    --user_pass="$USER_PASSWORD" --role=author --allow-root
else
  echo "✅ WordPress déjà installé — rien à faire"
fi

# Préparation PHP-FPM
mkdir -p /run/php
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "🚀 Lancement de PHP-FPM..."
exec "$@"