# data-engineering-lab-server-02

Segunda instancia independiente del proyecto educativo y profesional `data-engineering-lab`.

El objetivo de esta fase es desplegar una base minima reproducible para Ingenieria de Datos: PostgreSQL, pgAdmin, FastAPI, conexion real entre API y base de datos, persistencia, pruebas y documentacion.

## Problema que resuelve

Permite tener un entorno aislado para aprender y practicar despliegues de servicios de datos sin tocar el servidor anterior ni reutilizar sus contenedores, redes o volumenes.

## Arquitectura

```text
FastAPI -> PostgreSQL
pgAdmin -> PostgreSQL
```

Todos los servicios viven en la red `data_lab_server_02_network`.

## Tecnologias

- Python 3.12
- FastAPI
- SQLAlchemy
- psycopg
- Pydantic Settings
- PostgreSQL 16
- pgAdmin
- Docker
- Docker Compose
- pytest

## Directorio de instalacion

Ruta recomendada en Ubuntu:

```bash
/opt/data-engineering-lab-server-02
```

Si no tienes permisos sobre `/opt`:

```bash
~/data-engineering-lab-server-02
```

## Verificaciones previas

```bash
whoami
pwd
ls -la
docker --version
docker compose version
docker ps
sudo ss -tulpn
```

No asumas que `8100`, `5150` y `5433` estan libres.

## Crear `.env`

```bash
cp .env.example .env
```

Edita contrasenas:

```bash
nano .env
```

Cambia:

```env
POSTGRES_PASSWORD=change_this_password
PGADMIN_DEFAULT_PASSWORD=change_this_password
```

No subas `.env` a Git.

`.dockerignore` tambien evita que `.env` entre en la imagen Docker durante el build.

## Levantar servicios

```bash
make up
```

## Verificar servicios

```bash
make ps
make db-check
make health
make info
```

Respuesta esperada de `/health`:

```json
{
  "status": "ok",
  "database": "connected",
  "environment": "server-02"
}
```

Respuesta esperada de `/info`:

```json
{
  "project": "data-engineering-lab",
  "environment": "server-02",
  "version": "0.1.0"
}
```

## Acceder a FastAPI

```text
http://localhost:8100
```

Si usas SSH:

```bash
ssh -L 8100:localhost:8100 usuario@servidor
```

## Swagger

```text
http://localhost:8100/docs
```

## pgAdmin

```text
http://localhost:5150
```

Tunel SSH:

```bash
ssh -L 5150:localhost:5150 usuario@servidor
```

## Conectar pgAdmin a PostgreSQL

En pgAdmin:

- Host: `postgres`
- Port: `5432`
- Database: valor de `POSTGRES_DB`
- User: valor de `POSTGRES_USER`
- Password: valor de `POSTGRES_PASSWORD`

Usa `postgres`, no `localhost`, porque pgAdmin y PostgreSQL estan dentro de la misma red Docker.

## Ejecutar pruebas

```bash
make test
```

## Visualizar logs

```bash
make logs
make logs-api
make logs-db
```

## Detener el entorno

```bash
make down
```

Esto elimina contenedores de Compose, pero no borra volumenes.

## Reiniciar el entorno

```bash
make restart
```

O:

```bash
make down
make up
```

## Actualizar desde GitHub

Cuando exista remoto:

```bash
git pull origin main
make build
make up
make test
```

## Comprobar persistencia

```bash
docker volume inspect data_lab_server_02_postgres_data
make down
make up
```

Crea un dato de prueba antes de bajar servicios y verifica que siga existiendo despues.

## Backup

```bash
make backup
```

El backup queda en `backups/` y no se sube a Git.

## Restaurar backup

```bash
make restore BACKUP_FILE=backups/postgres_YYYYMMDD_HHMMSS.dump
```

El comando pide confirmacion antes de restaurar.

## Cambiar puerto externo

Edita `.env`:

```env
API_HOST_PORT=18100
PGADMIN_HOST_PORT=15150
POSTGRES_HOST_PORT=15433
```

No cambies los puertos internos salvo que tengas una razon tecnica clara.

## GitHub

No se crea remoto automaticamente. Para conectar:

```bash
git remote add origin URL_DEL_REPOSITORIO
git push -u origin main
```
