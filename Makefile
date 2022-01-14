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

build: ## rebuild all containers
	$(docker_compose_bin) build

up:  ## rebuild and up all containers
	$(docker_compose_bin) up -d --remove-orphans

down: ## down all containers
	$(docker_compose_bin) down

pull: ## down all containers
	$(docker_compose_bin) pull

deploy: down pull up

prune: ## clear all
	$(docker_bin) system prune



full-clean: ##
	$(docker_bin) image prune -a \
	&& $(docker_bin) container prune --filter "until=24h" \
	&& $(docker_bin) volume prune --filter "label!=keep" \
	&& $(docker_bin) network prune --filter "until=24h"
