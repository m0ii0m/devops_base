import pytest
import sys
import os

# Ajout du dossier parent au path pour importer app.py
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_get_state_missing_header(client):
    """Vérifie que l'appel sans X-User-ID renvoie 400"""
    rv = client.get('/api/state')
    assert rv.status_code == 400
    assert b"User ID missing" in rv.data

def test_get_state_valid(client):
    """Vérifie que l'appel avec X-User-ID fonctionne"""
    # Ce test nécessite un Redis en ligne (fourni par le Service dans GitHub Actions)
    rv = client.get('/api/state', headers={'X-User-ID': 'test_user'})
    # S'il arrive à se connecter à Redis, il renvoie 200 et un JSON
    # Sinon il plantera (ce qui est bon pour detecter une panne)
    assert rv.status_code == 200
    json_data = rv.get_json()
    assert "trombones" in json_data
