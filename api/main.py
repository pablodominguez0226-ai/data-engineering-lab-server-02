from typing import Literal

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel

from src.config.settings import get_settings
from src.database.connection import check_database_connection
from src.utils.logger import configure_logging, get_logger

configure_logging()
logger = get_logger(__name__)
settings = get_settings()


class HealthResponse(BaseModel):
    status: Literal["ok"]
    database: Literal["connected"]
    environment: Literal["server-02"]


class InfoResponse(BaseModel):
    project: Literal["data-engineering-lab"]
    environment: Literal["server-02"]
    version: str


app = FastAPI(
    title="Data Engineering Lab API - Server 02",
    version=settings.app_version,
    description="Second independent server instance for data-engineering-lab.",
)


@app.get("/health", response_model=HealthResponse)
def health_check() -> HealthResponse:
    database_is_connected = check_database_connection()

    if not database_is_connected:
        logger.error("Health check failed because PostgreSQL is not reachable")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={
                "status": "error",
                "database": "disconnected",
                "environment": settings.app_environment,
            },
        )

    logger.info("Health check completed successfully")
    return HealthResponse(
        status="ok",
        database="connected",
        environment="server-02",
    )


@app.get("/info", response_model=InfoResponse)
def project_info() -> InfoResponse:
    return InfoResponse(
        project=settings.app_project,
        environment=settings.app_environment,
        version=settings.app_version,
    )
