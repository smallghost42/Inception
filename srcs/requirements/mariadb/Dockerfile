FROM alpine:3.21
RUN apk add --no-cache mariadb mariadb-client

WORKDIR /app/data

ENTRYPOINT [ "mariadb_db_check.sh" ]

EXPOSE 3306

