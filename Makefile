SHELL := /bin/bash

-include .env

API_HOST_PORT ?= 8100
PGADMIN_HOST_PORT ?= 5150
POSTGRES_DB ?= data_lab_server_02
POSTGRES_USER ?= data_lab_user

.PHONY: up down build rebuild restart ps logs logs-api logs-db test health info db-check inspect status backup restore

up:
	docker compose up -d --build

down:
	docker compose down

build:
	docker compose build

rebuild:
	docker compose build --no-cache

restart:
	docker compose restart

ps:
	docker compose ps

logs:
	docker compose logs -f

logs-api:
	docker compose logs -f api

logs-db:
	docker compose logs -f postgres

test:
	docker compose exec api pytest -q

health:
	curl -fsS http://localhost:$(API_HOST_PORT)/health

info:
	curl -fsS http://localhost:$(API_HOST_PORT)/info

db-check:
	docker compose exec api python scripts/check_database.py

inspect:
	bash scripts/inspect_environment.sh

status:
	bash scripts/show_project_status.sh

backup:
	mkdir -p backups
	docker compose exec -T postgres pg_dump -U $(POSTGRES_USER) -d $(POSTGRES_DB) -Fc > backups/postgres_$$(date +%Y%m%d_%H%M%S).dump

restore:
	@if [ -z "$(BACKUP_FILE)" ]; then echo "Use: make restore BACKUP_FILE=backups/file.dump"; exit 1; fi
	@if [ ! -f "$(BACKUP_FILE)" ]; then echo "Backup file not found: $(BACKUP_FILE)"; exit 1; fi
	@read -p "This will restore into $(POSTGRES_DB). Continue? [y/N] " confirm; \
	if [ "$$confirm" != "y" ]; then echo "Restore cancelled"; exit 1; fi
	docker compose exec -T postgres pg_restore --clean --if-exists -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(BACKUP_FILE)
