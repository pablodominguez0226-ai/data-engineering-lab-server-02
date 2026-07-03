import sys

from pydantic import ValidationError

from src.config.settings import get_settings
from src.database.connection import check_database_connection
from src.utils.logger import configure_logging, get_logger

configure_logging()
logger = get_logger(__name__)


def main() -> int:
    try:
        settings = get_settings()
        logger.info(
            "Checking PostgreSQL connection using logical host %s:%s",
            settings.postgres_host,
            settings.postgres_port,
        )
    except ValidationError:
        logger.exception("Cannot read database settings from environment")
        return 1

    if check_database_connection():
        logger.info("PostgreSQL connection check succeeded")
        return 0

    logger.error("PostgreSQL connection check failed")
    return 1


if __name__ == "__main__":
    sys.exit(main())
