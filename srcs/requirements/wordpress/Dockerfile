FROM alpine:3.21
RUN apk add --no-cache php83-fpm php-mysql curl \
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  chmod +x wp-cli.phar \
  sudo mv wp-cli.phar /usr/local/bin/wp

WORKDIR /app/data

ENTRYPOINT [ "wordpress_db_check.sh" ]

EXPOSE 9000

CMD ["wp", "server", "--port=9000"]
