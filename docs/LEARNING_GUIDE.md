# Guia de aprendizaje

## Docker Compose

Docker Compose permite describir varios servicios en un solo archivo `docker-compose.yml`. En este proyecto levanta PostgreSQL, pgAdmin y FastAPI con una red y volumenes dedicados.

## Contenedor

Un contenedor es un proceso aislado que ejecuta una aplicacion con sus dependencias. Aqui hay contenedores separados para API, base de datos y administracion.

## Imagen

Una imagen es la plantilla desde la cual se crea un contenedor. PostgreSQL usa `postgres:16`, pgAdmin usa `dpage/pgadmin4`, y la API se construye con el `Dockerfile`.

## Red Docker

La red `data_lab_server_02_network` permite que los contenedores se encuentren por nombre. Por eso la API usa `postgres` como host.

## Volumen

Un volumen conserva datos fuera del ciclo de vida del contenedor. Si se borra y recrea el contenedor PostgreSQL, los datos siguen en `data_lab_server_02_postgres_data`.

## Persistencia de PostgreSQL

PostgreSQL necesita persistencia porque una base de datos sin volumen perderia sus datos al recrear el contenedor.

## Conexion FastAPI a PostgreSQL

FastAPI usa SQLAlchemy y psycopg. La URL de conexion se arma desde variables de entorno en `src/config/settings.py`.

## Archivo `.env`

El archivo `.env` guarda configuracion local y credenciales. No se sube a Git. `.env.example` sirve como plantilla segura.

## Archivo `.gitignore`

`.gitignore` evita subir credenciales, caches, logs locales y backups.

## Archivo `.dockerignore`

`.dockerignore` evita copiar credenciales, backups, logs y datos locales dentro de la imagen Docker.

## Healthcheck

El healthcheck de PostgreSQL ejecuta `pg_isready`. La API espera a que PostgreSQL este saludable antes de arrancar.

## Logs

Usa:

```bash
make logs
make logs-api
make logs-db
```

Lee primero el servicio que falla. Si `/health` devuelve `503`, revisa logs de `api` y despues de `postgres`.

## Diagnosticar conexion fallida

1. `make ps`: confirma que los contenedores esten corriendo.
2. `make logs-db`: revisa errores de PostgreSQL.
3. `make logs-api`: revisa errores de conexion.
4. `make db-check`: prueba `SELECT 1`.
5. Verifica `.env`: host `postgres`, puerto interno `5432`, usuario, base y password.

## Distinguir el origen del problema

- Docker: contenedores no aparecen o puertos no publican.
- API: contenedor corre, pero `/health` responde `503`.
- PostgreSQL: healthcheck no pasa o hay errores de credenciales.
