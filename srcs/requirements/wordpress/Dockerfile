FROM alpine:3.21

RUN apk add --no-cache php83-fpm php-mysqli curl
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

WORKDIR /app

COPY ./conf/wordpress_db_check.sh /app
RUN chmod +x /app/wordpress_db_check.sh

ENV PATH="/app:$PATH"

WORKDIR /app/data

ENTRYPOINT [ "wordpress_db_check.sh" ]

EXPOSE 9000

CMD ["wp", "server", "--port=9000"]
