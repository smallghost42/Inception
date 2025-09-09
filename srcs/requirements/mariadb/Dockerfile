FROM alpine:3.21
RUN apk add --no-cache mariadb mariadb-client

WORKDIR /app

COPY ./conf/mariadb_db_check.sh /app
RUN chmod +x /app/mariadb_db_check.sh

ENV PATH="/app:$PATH"

ENTRYPOINT [ "mariadb_db_check.sh" ]
