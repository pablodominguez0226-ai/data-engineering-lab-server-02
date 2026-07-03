from fastapi.testclient import TestClient

from api import main as api_main


def test_health_returns_ok_when_database_is_connected(monkeypatch) -> None:
    monkeypatch.setattr(api_main, "check_database_connection", lambda: True)

    client = TestClient(api_main.app)
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "database": "connected",
        "environment": "server-02",
    }


def test_health_returns_503_when_database_is_disconnected(monkeypatch) -> None:
    monkeypatch.setattr(api_main, "check_database_connection", lambda: False)

    client = TestClient(api_main.app)
    response = client.get("/health")

    assert response.status_code == 503
    assert response.json() == {
        "detail": {
            "status": "error",
            "database": "disconnected",
            "environment": "server-02",
        }
    }


def test_info_returns_project_metadata() -> None:
    client = TestClient(api_main.app)
    response = client.get("/info")

    assert response.status_code == 200
    assert response.json() == {
        "project": "data-engineering-lab",
        "environment": "server-02",
        "version": "0.1.0",
    }
