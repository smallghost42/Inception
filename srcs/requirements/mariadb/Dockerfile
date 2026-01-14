FROM alpine:3.22
RUN apk add --no-cache mariadb mariadb-client bash

WORKDIR /app

COPY ./conf/mariadb_db_check.sh /app
RUN chmod +x /app/mariadb_db_check.sh

ENV PATH="/app:$PATH"

WORKDIR /app/data/

ENTRYPOINT [ "mariadb_db_check.sh"]
