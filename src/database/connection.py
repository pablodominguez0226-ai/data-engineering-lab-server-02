from functools import lru_cache

from pydantic import ValidationError
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine
from sqlalchemy.exc import SQLAlchemyError

from src.config.settings import get_settings
from src.utils.logger import get_logger

logger = get_logger(__name__)


@lru_cache
def get_engine() -> Engine:
    settings = get_settings()
    return create_engine(
        settings.database_url,
        pool_pre_ping=True,
        pool_size=5,
        max_overflow=5,
    )


def check_database_connection() -> bool:
    try:
        engine = get_engine()
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            return result.scalar_one() == 1
    except ValidationError:
        logger.exception("Database configuration is invalid or incomplete")
        return False
    except SQLAlchemyError:
        logger.exception("Database connection check failed")
        return False
