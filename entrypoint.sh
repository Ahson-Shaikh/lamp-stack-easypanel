#!/usr/bin/env bash
set -e

# Defaults (you can override at runtime)
: "${MYSQL_HOST:=mysql}"
: "${MYSQL_PORT:=3306}"
: "${MYSQL_DATABASE:=app}"
: "${MYSQL_USER:=app}"
: "${MYSQL_PASSWORD:=app}"

# Optional: write a runtime PHP config file your app can include
cat > /var/www/html/.env.runtime.php <<EOF
<?php
return [
  'MYSQL_HOST' => '${MYSQL_HOST}',
  'MYSQL_PORT' => '${MYSQL_PORT}',
  'MYSQL_DATABASE' => '${MYSQL_DATABASE}',
  'MYSQL_USER' => '${MYSQL_USER}',
  'MYSQL_PASSWORD' => '${MYSQL_PASSWORD}',
];
EOF

exec "$@"
