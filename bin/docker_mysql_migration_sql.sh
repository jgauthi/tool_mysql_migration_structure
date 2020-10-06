#!/bin/bash
#set -xv
# [Docker version] mysql_migration_sql
# @arguments:
# - container: you can get container NAME or ID with `docker ps` command
# - database_name
# - chemin_dossier_migration_sql_script_in_docker
# - php service name (optional, default value: php)
# - user (optional, default value: local)
# - pass (optional, default value: local)
# - server (optional, default value: localhost)
# - port (optional, default value: 3306)
# - charset (optional, default value: utf8)

# Alteration from_script CONF
container=$1
database=$2
folder_migration="$3" # Folder location in docker
user=$4
pass=$5
host=$6
port=$7
charset=$8

if [ -z "$container" ]; then
	echo "Argument Container require, you can get container NAME or ID with 'docker ps' command"
	exit
fi
if [ -z "$database" ]; then
	echo "Argument Database require"
	exit
fi
if [ -z "$folder_migration" ]; then
	echo "Argument folder_migration require (Folder location in docker)"
	exit 1
fi

if [ -z "$user" ]; then user=local; fi
if [ -z "$pass" ]; then pass=local; fi
if [ -z "$host" ]; then host=localhost; fi
if [ -z "$port" ]; then port=3306; fi
if [ -z "$charset" ]; then charset=utf8; fi

# Copy the from_script inside the container, use it and remove
from_script=$(realpath $(dirname $0)/../src/alteration_maj_docker.php)
to_script="/tmp/maj_database.php"

docker cp "$from_script" "${container}:${to_script}"

docker exec -it "$container" php -d memory_limit=1500M "$to_script" "$database" "$folder_migration" "$user" "$pass" "$host" "$port"
docker exec -it "$container" rm -f "$to_script"
