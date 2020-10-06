# Database connexion settings (.env)
ifneq ("$(wildcard .env)","")
	include .env
	export $(shell sed 's/=.*//' .env)
endif

# Init var
DOCKER_COMPOSE?=docker-compose
EXEC?=$(DOCKER_COMPOSE) exec -u www-data web
EXEC_ROOT?=$(DOCKER_COMPOSE) exec -u root web
FOLDER_MIGRATION=/var/www/sql

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

up: up-ci  ## Start project with docker-compose + Dev env

stop:  ## Stop docker containers
	@$(DOCKER_COMPOSE) stop

restart: stop up-ci  ## Restart docker containers
install: build up perm  ## Create and start docker containers
reset: uninstall install  ## Remove and re-create docker containers

uninstall: stop  ## Remove docker containers
	@$(DOCKER_COMPOSE) rm -vf

shell:  ## Run app container in interactive mode
	@$(EXEC) /bin/bash

db-migration-structure:	## Install database migrations sqlfiles present on /var/www/sql folder (in docker)
	@php_container_name=$$(docker-compose ps web | tail -n +3 | awk '{ print $$1 }');\
    ./../../bin/docker_mysql_migration_sql.sh $$php_container_name $(MYSQL_DATABASE)\
       $(FOLDER_MIGRATION) $(MYSQL_USER) $(MYSQL_PASSWORD) $(MYSQL_HOST) $(MYSQL_PORT)

# OR via composer dependency
# ./vendor/bin/docker_mysql_migration_sql.sh [...]



# Internal rules
build:
	@$(DOCKER_COMPOSE) pull --ignore-pull-failures
	@$(DOCKER_COMPOSE) build --force-rm

up-ci:
	@$(DOCKER_COMPOSE) up -d

perm:
	@$(EXEC_ROOT) chown -R www-data:www-data /var/www
	@$(EXEC_ROOT) chmod 775 /var/www/sql
