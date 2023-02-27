ifneq (,$(wildcard ./.env))
  include .env
  export
endif

DOCKER_COMPOSE = docker compose -f config/docker/docker-compose.yml -f config/docker/docker-compose.$(APP_ENV).yml

## General ————————————————————————————————————————————————————————————

.DEFAULT_GOAL = help
.PHONY        : help clean env.dev env.test env.prod docker.up docker.start docker.down docker.logs

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

clean: ## Remove any built files (node_modules, vendor, var, etc..).
	@./bin/clean
	
## Environment ————————————————————————————————————————————————————————————

env.dev: # Init the dev environment.
	@node ./bin/env dev

env.test: # Init the test environment.
	@node ./bin/env test

env.prod: # Init the prod environment.
	@node ./bin/env prod

## Docker ————————————————————————————————————————————————————————————

docker.start: docker.build docker.up ## Build and start the Docker containers.

docker.build: ## Build the Docker images.
	$(DOCKER_COMPOSE) build --pull --no-cache

docker.up: ## Start the Docker environment.
	@$(DOCKER_COMPOSE) up --detach

docker.down: ## Stop the Docker environment.
	@$(DOCKER_COMPOSE) down --remove-orphans

docker.logs: ## Output the Docker logs.
	@$(DOCKER_COMPOSE) logs --tail=0 --follow