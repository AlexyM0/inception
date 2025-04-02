# nginx/Dockerfile

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/nginx /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -subj "/C=FR/ST=IDF/L=Paris/O=Dev/OU=Dev/CN=localhost" \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

