FROM alpine:3.21
RUN apk add --no-cache php83-fpm curl \
    && adduser -u 82 -D -S -G www-data www-data

WORKDIR /var/www/html

RUN curl -o latest.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && rm latest.tar.gz

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm83", "-F"]
