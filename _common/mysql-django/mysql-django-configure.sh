#!/usr/bin/env bash
echo loggg2 > /log

set -Eeuo pipefail
set -x

echo 'AAAAAAAAAAAAAAAAAAAAAAAa'

# set_mysql_option() {
#     local CONFFILE="$1"
#     local OPTION="$2"
#     local VALUE="$3"

#     if grep -q "$OPTION" "$CONFFILE"; then
#         sed -i "s/^#*${OPTION}\\s*=.*/${OPTION} = ${VALUE}/g" "$CONFFILE"
#     else
#         echo "${OPTION} = ${VALUE}" >> "$CONFFILE"
#     fi

# }

# set_mysql_option "/etc/mysql/my.cnf" bind-address 0.0.0.0

# mysql -u root --password="$MYSQL_ROOT_PASSWORD" \
# --execute "SET GLOBAL innodb_file_format=Barracuda;
# SET GLOBAL innodb_file_per_table=ON;
# SET GLOBAL innodb_large_prefix=1;"


for name in djangoproject code.djangoproject; do
    mysql -u root --password="$MYSQL_ROOT_PASSWORD" \
    --execute "CREATE DATABASE \`$name\` CHARACTER SET utf8;" \
    --execute "use \`$name\`; CREATE USER \`$name\` IDENTIFIED BY '$MYSQL_DJANGO_PASSWORD';" \
    --execute "use \`$name\`; GRANT ALL PRIVILEGES ON \`$name\`.'*' TO \`$name\` WITH GRANT OPTION;"
done
