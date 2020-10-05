#!/bin/bash

# Config
dir_alter=../example/migration_structures
logfile=`pwd`/install_batch_sql_error.log
host='localhost'
port='3306'
charset='utf8'

db_user='local'
db_pass='local'
db_base='dbname'

mysql_var="--host=$host --port=$port --default-character-set=$charset -u $db_user --password=$db_pass"

# Ajout des alterations de la base de donnée
for i in `php ../src/alteration_maj_database.php $db_base $db_user $db_pass $dir_alter/`
do
	if [ -n $i ] && [ -e $dir_alter/$i ]; then
		mysql $mysql_var $db_base < $dir_alter/$i 2>>$logfile
		mysql $mysql_var $db_base -e "INSERT INTO migration_structures SET script_name = '$i';"
	fi
done

mysql --host=$host --port=$port -u $db_user --password=$db_pass $db_base -e "PURGE BINARY LOGS BEFORE DATE_SUB(NOW(), INTERVAL 1 WEEK)"
