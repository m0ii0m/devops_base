import pytest
import json
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

def test_get_initial_state(client):
    """Test si l'API renvoie bien l'état initial"""
    response = client.get('/api/state')
    
    # Vérifie que le serveur répond 200 OK
    assert response.status_code == 200
    
    data = json.loads(response.data)
    
    # Vérifie que les données contiennent les clés du jeu
    assert "trombones" in data
    assert "production_rate" in data

def test_save_state(client):
    """Test si la sauvegarde fonctionne"""
    new_state = {
        "trombones": 100,
        "production_rate": 5
    }
    
    response = client.post('/api/save', 
                         data=json.dumps(new_state),
                         content_type='application/json')
    
    assert response.status_code == 200
    
    # Vérifie que la réponse confirme la sauvegarde
    data = json.loads(response.data)
    assert data["state"]["trombones"] == 100