
ENV	:= $(PWD)/.env
include $(ENV)
include $(ENV).$(APP_ENV)
export

ifeq ($(APP_ENV),prod)
  DOCKER_COMPOSE=docker compose -f docker-compose.yml -f docker-compose.prod.yml
else
  DOCKER_COMPOSE=docker compose
endif

## General ————————————————————————————————————————————————————————————

.DEFAULT_GOAL = help
.PHONY        : help up build start down logs

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## Docker ————————————————————————————————————————————————————————————

start: build up ## Build and start the Docker containers.

build: ## Build the Docker images.
	@$(DOCKER_COMPOSE) build --pull --no-cache

up: ## Start the Docker environment.
	@$(DOCKER_COMPOSE) up --detach

down: ## Stop the Docker environment.
	@$(DOCKER_COMPOSE) down --remove-orphans

logs: ## Output the Docker logs.
	@$(DOCKER_COMPOSE) logs --tail=0 --follow
