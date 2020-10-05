set dir_alter=..\example\migration_structures\
set logfile=/install_batch_sql_error.log
set host=localhost
set port=3306
set charset=utf8

set db_user=local
set db_pass=local
set db_base=dbname

set mysql_var=--host=%host% --port=%port% --default-character-set=%charset% -u %db_user% --password=%db_pass%

FOR /f "tokens=* delims=" %%X IN ('php alteration_maj_database.php "%db_base%" "%db_user%" "%db_pass%" %dir_alter%') DO (
	if exist %dir_alter%%%X (
		mysql %mysql_var% %db_base% < %dir_alter%%%X
		mysql %mysql_var% %db_base% -e "INSERT INTO `migration_structures` SET script_name = '%%X';"

	) else echo %%X
)
