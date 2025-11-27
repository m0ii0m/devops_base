import os
import json
from flask import Flask, jsonify, request
from flask_cors import CORS
import redis

app = Flask(__name__)
CORS(app)

# Connexion à Redis
# On récupère l'hôte depuis la variable d'environnement (défini dans docker-compose)
redis_host = os.environ.get('REDIS_HOST', 'localhost')
r = redis.Redis(host=redis_host, port=6379, decode_responses=True)

# Valeurs par défaut si la DB est vide
DEFAULT_STATE = {
    "trombones": 0,
    "production_rate": 0
}

@app.route('/api/state', methods=['GET'])
def get_state():
    # Tenter de récupérer l'état sauvegardé
    saved_state = r.get('game_state')
    
    if saved_state:
        return jsonify(json.loads(saved_state))
    else:
        return jsonify(DEFAULT_STATE)

@app.route('/api/save', methods=['POST'])
def save_state():
    data = request.json
    # Sauvegarde dans Redis (on convertit le dict en string JSON)
    r.set('game_state', json.dumps(data))
    return jsonify({"status": "success", "state": data})

# Route de reset (Utile pour tester le CRUD complet : Delete)
@app.route('/api/reset', methods=['DELETE'])
def reset_state():
    r.delete('game_state')
    return jsonify(DEFAULT_STATE)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)