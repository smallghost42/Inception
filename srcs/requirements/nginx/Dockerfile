FROM alpine:3.21
RUN apk add --no-cache nginx openssl
RUN mkdir -p /etc/nginx/ssl/private \
  /etc/nginx/ssl/certs \
  /etc/nginx/http.d

# -x509: output a self-signed certificate instead of a certificate request
# -nodes: no DES (don't encrypt the private key)
# -days 365: certificate validity for 365 days
# -newkey rsa:2048: generate a new 2048-bit RSA private key
# -keyout: specify output file for the private key
# -out: specify output file for the certificate
# -subj: provide subject information non-interactively. Adjust these values as needed.
RUN openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt \
  -subj "/C=MD/ST=Tana/L=Tana/O=None/OU=None/CN=localhost"

COPY ./conf/default.conf /etc/nginx/http.d/default.conf
COPY ./conf/index.html /usr/share/nginx/index.html

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
