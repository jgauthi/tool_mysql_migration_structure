# Tool Mysql Migration Structure
Tool to migrate a mysql database from migration files (*.sql). Useful for legacy projects, without framework.

## Prerequisite

* PHP 5.6+ (v1)
* Mysql 5.6, or 5.7, or 8
* (Optional) Docker v18+
* (Optional) Docker compose

## Install
`composer install`

Or you can add this poc like a dependency, in this case edit your [composer.json](https://getcomposer.org) (launch `composer update` after edit):

```json
{
  "repositories": [
    { "type": "git", "url": "git@github.com:jgauthi/tool_mysql_migration_structure.git" }
  ],
  "require": {
    "jgauthi/tool_mysql_migration_structure": "1.*"
  }
}
```

## Usage
Install migrations structure (*.sql files) with line commands:

```shell script
./bin/mysql_migration_sql.sh "$database" "$folder_migration" "$user" "$pass" "$host"

# OR if this tool is installed like composer dependency
./vendor/bin/mysql_migration_sql.sh "$database" "$folder_migration" "$user" "$pass" "$host"
```

The **first use** creates the `migration_structures` table in the database, with all migrations (not executed): the script cannot know which script has already been used or not. The **second and future use** installs the missing files in the table.

If you want to force the installation of a migration, you can remove it from the table and reuse the script.

The migration files are executed in alphabetical order, it is advisable to name them in the form `YYYY-MM-DD_name.sql`.


## Usage with docker
You can use the script docker version to update mysql database.

```shell script
./bin/docker_mysql_migration_sql.sh "$php_container_name" "$database" "$folder_migration" "$user" "$pass" "$host"

# OR if this tool is installed like composer dependency
./vendor/bin/docker_mysql_migration_sql.sh [...]
```

* `$folder_migration` must be the fullpath migration folder **in docker** _(/var/www/sql in [example](example/docker/docker-compose.yml))_.
* `$php_container_name` is the php container NAME or ID, you can get with `docker ps` command OR you can use this command in docker-compose project:

```shell script
# Complete php service name (from docker-compose.yml)
docker_php_service=web

php_container_name=$(docker-compose ps ${docker_php_service} | tail -n +3 | awk '{ print $1 }')
```


## Documentation
You can look at [folder example](example).

