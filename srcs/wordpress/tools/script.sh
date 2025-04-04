#!/bin/bash
set -e

cd /var/www/html && rm -rf ./*

# Installer wp-cli
if ! command -v wp &> /dev/null; then
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x ./wp-cli.phar
  mv ./wp-cli.phar /usr/local/bin/wp
fi

# Attendre que MariaDB soit prêt
until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
	echo "⏳ En attente de MariaDB..."
	sleep 2
done

if [ -f ./wp-config.php ]; then
	echo "✅ WordPress déjà installé"
else
	wp core download --allow-root

	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/mariadb:3306/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php

	cp wp-config-sample.php wp-config.php

	# Tu peux décommenter ceci si tu veux auto-installer :
	# wp core install --url="https://almichel.42.fr" \
	#   --title="Mon Blog" --admin_user="$ADMIN_USER" \
	#   --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_MAIL" \
	#   --skip-email --allow-root
fi

mkdir -p /run/php

exec "$@"
