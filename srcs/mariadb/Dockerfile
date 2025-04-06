FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install mariadb-server -y

RUN apt-get install procps -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/auto_config.sh /auto_config.sh

ENTRYPOINT ["/bin/sh", "auto_config.sh"]

EXPOSE 3306