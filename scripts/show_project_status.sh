#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${PROJECT_DIR}"

echo "Project path: ${PROJECT_DIR}"
echo "Git branch: $(git branch --show-current 2>/dev/null || echo 'not a git repository')"
echo "Last commit: $(git log -1 --oneline 2>/dev/null || echo 'no commits yet')"
echo

echo "Modified files:"
git status --short 2>/dev/null || echo "not a git repository"
echo

echo "Docker Compose status:"
docker compose ps || true
echo

echo "Healthchecks:"
docker inspect data_lab_server_02_postgres --format '{{json .State.Health}}' 2>/dev/null || echo "postgres container not found"
echo

echo "URLs:"
echo "FastAPI: http://localhost:${API_HOST_PORT:-8100}"
echo "Swagger: http://localhost:${API_HOST_PORT:-8100}/docs"
echo "pgAdmin: http://localhost:${PGADMIN_HOST_PORT:-5150}"
echo

echo "Last API logs:"
docker compose logs --tail=30 api || true
echo

echo "Last PostgreSQL logs:"
docker compose logs --tail=30 postgres || true
