#!/bin/sh

# Disable TLSv1.1
sed -i 's/ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;/#ssl_protocols TLSv1.2 TLSv1.3;/g' /etc/nginx/nginx.conf

sed -i "s/EXPOSED_PORT/${EXPOSED_PORT}/g" /etc/nginx/http.d/default.conf

sed -i "s/WP_PORT/${WP_PORT}/g" /etc/nginx/http.d/default.conf

exec nginx -g "daemon off;"