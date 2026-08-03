#!/bin/bash
set -euo pipefail
: "${PHPBB_DB_HOST:?PHPBB_DB_HOST is required}" "${PHPBB_DB_PASSWORD:?PHPBB_DB_PASSWORD is required}" "${PHPBB_ADMIN_PASSWORD:?PHPBB_ADMIN_PASSWORD is required}" "${PHPBB_SERVER_NAME:?PHPBB_SERVER_NAME is required}"
if [ ! -f /var/www/html/bin/phpbbcli.php ]; then
  rm -rf /var/www/html/*
  cp -a /opt/phpbb/. /var/www/html/
fi
printf 'ok\n' >/var/www/html/healthz.txt
chown -R www-data:www-data /var/www/html
if [ ! -s /var/www/html/config.php ]; then
  cat >/tmp/phpbb-install.yml <<EOF
installer:
  admin:
    name: admin
    password: ${PHPBB_ADMIN_PASSWORD}
    email: ${PHPBB_ADMIN_EMAIL:-admin@example.com}
  board:
    lang: en
    name: ${PHPBB_BOARD_NAME:-phpBB on Railway}
    description: A private-ready phpBB community
  database:
    dbms: mysqli
    dbhost: ${PHPBB_DB_HOST}
    dbport: ${PHPBB_DB_PORT:-3306}
    dbuser: ${PHPBB_DB_USER:-phpbb}
    dbpasswd: ${PHPBB_DB_PASSWORD}
    dbname: ${PHPBB_DB_NAME:-phpbb}
    table_prefix: phpbb_
  email:
    enabled: false
    smtp_delivery: ~
    smtp_host: ~
    smtp_port: ~
    smtp_auth: ~
    smtp_user: ~
    smtp_pass: ~
  server:
    cookie_secure: true
    server_protocol: https://
    force_server_vars: true
    server_name: ${PHPBB_SERVER_NAME}
    server_port: 443
    script_path: /
  extensions: []
EOF
  cd /var/www/html
  runuser -u www-data -- php install/phpbbcli.php install /tmp/phpbb-install.yml
fi
[ ! -d /var/www/html/install ] || mv /var/www/html/install /var/www/html/.install
sed -ri 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
sed -ri 's/:80>/:8080>/' /etc/apache2/sites-available/000-default.conf
rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf /etc/apache2/mods-enabled/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.conf
a2enmod mpm_prefork >/dev/null
exec apache2-foreground
