from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app) # Autorise le frontend Vue à parler au backend

# État du jeu (Simulé en mémoire pour l'instant)
game_state = {
    "trombones": 0,
    "production_rate": 0
}

@app.route('/api/state', methods=['GET'])
def get_state():
    return jsonify(game_state)

@app.route('/api/save', methods=['POST'])
def save_state():
    global game_state
    data = request.json
    # Ici, vous pourrez ajouter des tests pour vérifier que le user ne triche pas
    game_state = data
    return jsonify({"status": "success", "state": game_state})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)