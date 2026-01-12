FROM alpine:3.21

RUN apk add --no-cache php php83-fpm php-mysqli php-phar curl netcat-openbsd mysql-client php-mbstring php-iconv
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN sed -i 's/^memory_limit = .*/memory_limit = 1024M/' /etc/php83/php.ini
RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php83/php-fpm.d/www.conf

WORKDIR /app

COPY ./conf/wordpress_db_check.sh /app
RUN chmod +x /app/wordpress_db_check.sh

ENV PATH="/app:$PATH"

WORKDIR /app/data

ENTRYPOINT [ "wordpress_db_check.sh" ]
