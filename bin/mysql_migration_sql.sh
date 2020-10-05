#!/bin/bash
#set -xv
# @arguments:
# - database_name
# - chemin_dossier_migration_sql_script
# - user (optional, default value: local)
# - pass (optional, default value: local)
# - server (optional, default value: localhost)
# - port (optional, default value: 3306)
# - charset (optional, default value: utf8)

# Alteration script CONF
database=$1
folder_migration=$2
user=$3
pass=$4
host=$5
port=$6
charset=$7

if [ -z "$database" ]; then echo "Argument Database require"; exit; fi
if [ ! -d "$folder_migration" ]; then
	echo "Argument folder_migration require with valid folder, current value: $folder_migration"
	exit 1
fi

if [ -z "$user" ]; then user=local; fi
if [ -z "$pass" ]; then pass=local; fi
if [ -z "$host" ]; then host=localhost; fi
if [ -z "$port" ]; then port=3306; fi
if [ -z "$charset" ]; then charset=utf8; fi


# Shell script CONF
command=mysql
mysql_command="$command --host=$host --port=$port --default-character-set=$charset -u $user"
script=$(realpath $(dirname $0)/../src/alteration_maj_database.php)

sqlFiles=$(php "$script" "$database" $(realpath "$folder_migration") "$user" "$pass" "$host" "$port")
if [ ! -z "$sqlFiles" ]; then
  echo "Launching database structural migrations on \"$database\":"
  export MYSQL_PWD=$pass;

  for sqlfile in $sqlFiles
   do
     file=$(realpath "$folder_migration/$sqlfile")
     if [ -f "$file" ]; then
        $mysql_command $database < "$file"
        $mysql_command $database -e "INSERT INTO migration_structures SET file = '$sqlfile'"
        echo "- $folder_migration/$sqlfile"

     else
        echo "- $folder_migration/$sqlfile doesn't exists"
     fi
  done
  $mysql_command $database -e "ALTER TABLE migration_structures ORDER BY dateAdd ASC;"
fi
