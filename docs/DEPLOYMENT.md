# Despliegue

Este documento registra la preparacion de `data-engineering-lab-server-02`.

No incluir contrasenas en este archivo.

## Datos del servidor

- Hostname: completar en el Ubuntu Server con `hostname`
- Fecha del despliegue: 2026-07-03
- Ruta recomendada: `/opt/data-engineering-lab-server-02`
- Ruta alternativa: `~/data-engineering-lab-server-02`
- Usuario que realiza el despliegue: completar con `whoami`

## Comandos previos

```bash
whoami
pwd
ls -la
docker --version
docker compose version
docker ps
sudo ss -tulpn
```

## Comandos de despliegue

```bash
cp .env.example .env
nano .env
make up
make ps
make db-check
make health
make info
make test
make status
```

## Contenedores creados

- `data_lab_server_02_postgres`
- `data_lab_server_02_pgadmin`
- `data_lab_server_02_api`

## Red creada

- `data_lab_server_02_network`

## Volumenes creados

- `data_lab_server_02_postgres_data`
- `data_lab_server_02_pgadmin_data`

## Puertos utilizados

- FastAPI host `8100` hacia contenedor `8000`
- pgAdmin host `5150` hacia contenedor `80`
- PostgreSQL host `5433` hacia contenedor `5432`

## Resultado de verificaciones

Completar luego del despliegue real en Ubuntu Server:

```text
docker compose ps:
make health:
make info:
make db-check:
make test:
```
