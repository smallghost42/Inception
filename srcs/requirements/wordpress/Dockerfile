FROM alpine:3.22

RUN apk add --no-cache \
    php \
    php83-fpm \
    php-mysqli \
    php-phar \
    php-tokenizer \
    php-json \
    php-openssl \
    php-curl \
    php-zlib \
    php-gd \
    php-dom \
    php-exif \
    php-fileinfo \
    php-simplexml \
    php-xmlreader \
    php-xmlwriter \
    curl \
    netcat-openbsd \
    mysql-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's/^memory_limit = .*/memory_limit = 256M/' /etc/php83/php.ini
RUN sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 64M/' /etc/php83/php.ini
RUN sed -i 's/^post_max_size = .*/post_max_size = 64M/' /etc/php83/php.ini

WORKDIR /app

COPY ./conf/wordpress_db_check.sh /app
RUN chmod +x /app/wordpress_db_check.sh

ENV PATH="/app:$PATH"

WORKDIR /app/data

ENTRYPOINT [ "wordpress_db_check.sh" ]