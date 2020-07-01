#!/usr/bin/env bash

set -Eeuo pipefail

set -x

cat > $DJANGOPROJECT_DATA_DIR/conf/secrets.json <<EOF
{
  "secret_key": "$(dd if=/dev/urandom bs=4 count=16 2>/dev/null | base64 | head -c 32)",
  "superfeedr_creds": ["email@example.com", "some_string"],
  "db_host": "$MYSQL_HOST",
  "db_password": "$MYSQL_DJANGO_PASSWORD",
  "trac_db_host": "$MYSQL_HOST",
  "trac_db_password": "$MYSQL_DJANGO_PASSWORD"
}
EOF

# mysql -u "root" \
#     --password="$MYSQL_ROOT_PASSWORD" \
#     -h "$MYSQL_HOST" \
#     -P 9494 \
#     code.djangoproject < /app/tracdb/mysql_trac.sql

ping $MYSQL_HOST -c 2

sleep 20;

/app/manage.py migrate
python3 /app/manage.py shell <<EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='${DJANGO_ADMIN_LOGIN}').count():
    User.objects.create_superuser('${DJANGO_ADMIN_LOGIN}', 'email@example.com', '${DJANGO_ADMIN_PASSWORD}')

EOF

/app/manage.py loaddata dev_sites
/app/manage.py loaddata dashboard_production_metrics
/app/manage.py update_metrics

cd /app
make compile-scss

exec make run
