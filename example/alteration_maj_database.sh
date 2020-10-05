#!/bin/bash
#set -xv

# Projet database settings
database=dev
host=localhost
port=3306
user=local
pass=local
folder_migration="$(dirname $0)/migration_structures"

$(dirname $0)/../bin/mysql_migration_sql.sh "$database" "$folder_migration" "$user" "$pass" "$host" "$port"


# Installed like dependency with composer
# In this example, the vendor folder is located in "example/"
#./vendor/bin/mysql_migration_sql.sh "$database" "$folder_migration" "$user" "$pass" "$host" "$port"
