FROM alpine:3.21

RUN apk add --no-cache php83-fpm php-mysqli curl
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

WORKDIR .

COPY ./conf/wordpress_db_check.sh .
RUN chmod +x /app/bin/wordpress_db_check.sh

ENTRYPOINT [ "wordpress_db_check.sh" ]

EXPOSE 9000

CMD ["wp", "server", "--port=9000"]
