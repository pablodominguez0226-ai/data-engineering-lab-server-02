# Arquitectura

## Diagrama textual

```text
Usuario / navegador / curl
        |
        | http://HOST:8100
        v
data_lab_server_02_api
        |
        | postgresql://postgres:5432
        v
data_lab_server_02_postgres

Usuario / navegador
        |
        | http://HOST:5150
        v
data_lab_server_02_pgadmin
        |
        | postgres:5432
        v
data_lab_server_02_postgres
```

## Servicios

- `api`: aplicacion FastAPI que expone `/health`, `/info` y Swagger.
- `postgres`: base PostgreSQL 16 con datos persistentes.
- `pgadmin`: interfaz web para administrar PostgreSQL.

## Comunicacion entre servicios

Los contenedores se comunican por la red Docker `data_lab_server_02_network`. Dentro de esa red, Docker resuelve el nombre del servicio `postgres` hacia el contenedor PostgreSQL.

Por eso la API y pgAdmin usan `postgres` como hostname. No usan `localhost`, porque `localhost` dentro de un contenedor apunta al propio contenedor, no a PostgreSQL.

## Red Docker

La red `data_lab_server_02_network` aísla esta segunda instancia del proyecto y evita colisiones con otros entornos.

## Volumenes

- `data_lab_server_02_postgres_data`: conserva los datos reales de PostgreSQL.
- `data_lab_server_02_pgadmin_data`: conserva configuracion de pgAdmin.

## Puertos

Puertos internos:

- API: `8000`
- pgAdmin: `80`
- PostgreSQL: `5432`

Puertos del host sugeridos:

- API: `8100`
- pgAdmin: `5150`
- PostgreSQL: `5433`

## Flujo de `/health`

1. El cliente llama `GET /health`.
2. FastAPI ejecuta `check_database_connection`.
3. SQLAlchemy abre una conexion a `postgres:5432`.
4. La API ejecuta `SELECT 1`.
5. Si PostgreSQL responde, devuelve `status=ok`.
6. Si falla, devuelve `503` sin exponer credenciales.
