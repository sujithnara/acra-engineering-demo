#!/usr/bin/env bash

set -Eeuo pipefail

set_pg_option() {
    local PG_CONFFILE="$1"
    local OPTION="$2"
    local VALUE="$3"
    if grep -q "$OPTION" "$PG_CONFFILE"; then
        sed -i "s/^#*${OPTION}\\s*=.*/${OPTION} = ${VALUE}/g" "$PG_CONFFILE"
    else
        echo "${OPTION} = ${VALUE}" >> "$PG_CONFFILE"
    fi
}

set_pg_option "$PGDATA/postgresql.conf" log_statement all

for name in djangoproject code.djangoproject; do
    mysql --username root --password="$MYSQL_ROOT_PASSWORD" <<EOSQL
CREATE DATABASE "$name";
GRANT ALL PRIVILEGES ON "$name" TO "$name" IDENTIFIED BY "$MYSQL_DJANGO_PASSWORD" WITH GRANT OPTION;
EOSQL
done


CREATE USER "djangoproject" WITH SUPERUSER NOCREATEDB NOCREATEROLE PASSWORD 'test' ;
CREATE DATABASE "$name" OWNER "$name" ;
