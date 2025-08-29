FROM alpine:3.21
RUN apk add --no-cache php83-fpm php-mysql curl \
  && adduser -u 82 -D -S -G www-data www-data

WORKDIR /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  wp core download \
  wp config create --dbname=wp_inceptiondb --dbuser=ferafano --dbpass=small --dbhost=localhost \
  wp db create


RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm83", "-F"]
