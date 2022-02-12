SHELL = /bin/sh

.DEFAULT_GOAL := help
docker_compose_bin := $(shell command -v docker-compose 2> /dev/null)
docker_bin:=$(shell command -v docker 2> /dev/null)

# This will output the help for each task.
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "\n  Allowed for overriding next properties:\n\n\
		Usage example:\n\
	    	make up"

sonar-conf: ## configure machine for Sonar needs
	sudo sysctl -w vm.max_map_count=524288 || echo 1 \
	&& sudo sysctl -w fs.file-max=131072 || echo 1 \
	&& sudo ulimit -n 131072 || echo 1 \
	&& sudo ulimit -u 8192 || echo 1

############# MANAGE ALL SERVICES ###############

build-all: ## rebuild all containers
	$(docker_compose_bin) build

up-all:  ## rebuild and up all containers
	$(docker_compose_bin) up -d --remove-orphans

down-all: ## down all containers
	$(docker_compose_bin) down

pull-all: ## down all containers
	$(docker_compose_bin) pull

deploy-all: down pull up

prune: ## clear all
	$(docker_bin) system prune

############# MANAGE ALL SERVICES ###############

############# ONLY SONAR DOCKER-COMPOSE ###############

build-sonar: ## rebuild all containers
	$(docker_compose_bin) -f sonarqube/docker-compose.yml build

up-sonar:  ## rebuild and up all containers
	$(docker_compose_bin) -f sonarqube/docker-compose.yml up -d --remove-orphans

down-sonar: ## down all containers
	$(docker_compose_bin) -f sonarqube/docker-compose.yml down

pull-sonar: ## down all containers
	$(docker_compose_bin) -f sonarqube/docker-compose.yml pull

deploy-sonar: down pull up

############# ONLY SONAR DOCKER-COMPOSE ###############

full-clean: ##
	$(docker_bin) image prune -a \
	&& $(docker_bin) container prune --filter "until=24h" \
	&& $(docker_bin) volume prune --filter "label!=keep" \
	&& $(docker_bin) network prune --filter "until=24h"
