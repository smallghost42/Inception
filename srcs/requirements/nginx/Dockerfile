FROM alpine:3.22
RUN apk add --no-cache nginx openssl
RUN mkdir -p /etc/nginx/ssl/private \
  /etc/nginx/ssl/certs \
  /etc/nginx/http.d

RUN openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt \
  -subj "/C=MD/ST=Tana/L=Tana/O=None/OU=None/CN=localhost"

WORKDIR /app
  
COPY ./conf/default.conf /etc/nginx/http.d/default.conf
COPY ./conf/nginx_default.sh /app
RUN chmod +x /app/nginx_default.sh

ENV PATH="/app:$PATH"


ENTRYPOINT [ "nginx_default.sh" ]
