# Tool Mysql Migration Structure
Tool to migrate a mysql database from migration files (*.sql). Useful for legacy projects, without framework.

## Prerequisite

* PHP 5.6+ (v1)

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


## Documentation
You can look at [folder example](example).

