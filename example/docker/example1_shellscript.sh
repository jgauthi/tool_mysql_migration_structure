#!/bin/bash
#set -xv
# Docker usage with terminal / shell script

# Installation and launch docker:
# `docker-compose up -d`
# ...

# [IF Docker compose] php container
docker_php_service=web
php_container_name=$(docker-compose ps ${docker_php_service} | tail -n +3 | awk '{ print $1 }')

# [IF Docker] You can get php container name with `docker ps` command
# php_container_name=example_migration_web_1


# Projet database settings
database=dbname
user=localdocker
pass=localpass
port=3306

# [IF Docker] host or IP mysql server, 'localhost' if mysql is installed inside the php container
# [IF Docker compose] mysql service name
host=dbmysql

# Migration folder location in docker
folder_migration="/var/www/sql"

$(dirname $0)/../../bin/docker_mysql_migration_sql.sh "$php_container_name" "$database" "$folder_migration" "$user" "$pass" "$host" "$port"

# Installed like dependency with composer
# In this example, the vendor folder is located in "example/"
#./vendor/bin/docker_mysql_migration_sql.sh [...]


# Display last migration files
docker-compose exec -T $host mysql -u $user --password=$pass $database \
  -e "SELECT * FROM migration_structures ORDER BY dateAdd DESC LIMIT 10"
