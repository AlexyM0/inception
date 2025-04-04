FROM debian:bullseye

RUN	apt update -y \
        && apt upgrade -y \
	&& apt-get install curl -y \
	&& apt-get install -y php php-cgi php-fpm php-mysql mariadb-client \
	&& mkdir -p /var/www/html

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/script.sh /home/script.sh

RUN chmod +x /home/script.sh

WORKDIR /var/www/html/

EXPOSE 9000

ENTRYPOINT ["/home/script.sh"]

CMD ["/usr/sbin/php-fpm7.4", "-F"]
