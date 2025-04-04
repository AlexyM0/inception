#!/bin/bash
set -e

echo "📂 Dossier courant : $(pwd)"
echo "💬 Commande CMD reçue : $@"

cd /var/www/html && rm -rf ./*
echo "🧹 Dossier vidé"

if ! command -v wp &> /dev/null; then
  echo "📦 Téléchargement de WP-CLI..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x ./wp-cli.phar
  mv ./wp-cli.phar /usr/local/bin/wp
fi

echo "🔁 Test MariaDB"
until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
	echo "⏳ En attente de MariaDB..."
	sleep 2
done

if [ -f ./wp-config.php ]; then
  echo "✅ WordPress déjà installé"
else
  echo "📥 Téléchargement de WordPress..."
  wp core download --allow-root

  echo "⚙️ Configuration de wp-config.php..."
  sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
  sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
  sed -i "s/localhost/mariadb:3306/g" wp-config-sample.php
  sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
  cp wp-config-sample.php wp-config.php
fi

mkdir -p /run/php
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "🚀 Lancement de PHP-FPM..."
exec "$@"
cement de PHP-FPM..."
exec "$@"