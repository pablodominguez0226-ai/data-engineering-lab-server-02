#!/usr/bin/env bash
set -euo pipefail

PROJECT_PREFIX="data_lab_server_02"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "User: $(whoami)"
echo "Hostname: $(hostname)"
echo "Local IP addresses:"
hostname -I 2>/dev/null || ip -brief address 2>/dev/null || true
echo "Project directory: ${PROJECT_DIR}"
echo

echo "Docker version:"
docker --version
echo

echo "Docker Compose version:"
docker compose version
echo

echo "Project containers:"
docker ps -a --filter "name=${PROJECT_PREFIX}" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
echo

echo "Project networks:"
docker network ls --filter "name=${PROJECT_PREFIX}" --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"
echo

echo "Project volumes:"
docker volume ls --filter "name=${PROJECT_PREFIX}" --format "table {{.Name}}\t{{.Driver}}"
echo

echo "Project ports in use:"
if command -v ss >/dev/null 2>&1; then
  ss -tulpn | grep -E ':(8100|5150|5433)\b' || true
else
  echo "ss command is not available"
fi
echo

echo "Disk space:"
df -h "${PROJECT_DIR}"
