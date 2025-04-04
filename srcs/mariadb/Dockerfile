FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Installation de MariaDB
RUN apt update && \
    apt install -y mariadb-server && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chmod 755 /run/mysqld

# Copie de la config MariaDB (pour bind-address)
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Script SQL d'initialisation
COPY tools/init.sql /docker-entrypoint-initdb.d/init.sql

# Entrypoint custom
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]