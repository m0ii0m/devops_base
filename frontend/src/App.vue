<script setup>
import { ref, onMounted } from 'vue'

const trombones = ref(0)
const productionRate = ref(0)
const clickValue = ref(1)
const autoClipperCost = ref(50)

// --- NOUVEAU : Charger la partie au lancement ---
onMounted(() => {
  loadGame()
  // Lancer la boucle de sauvegarde auto toutes les 10 secondes (optionnel mais cool)
  setInterval(saveGame, 10000)
})

const loadGame = async () => {
  try {
    const response = await fetch('http://localhost:5000/api/state') 
    const data = await response.json()
    
    if (data) {
      trombones.value = data.trombones || 0
      productionRate.value = data.production_rate || 0
      if (productionRate.value > 0) {
         autoClipperCost.value = 50 * Math.pow(1.5, productionRate.value)
      }
    }
  } catch (e) {
    console.error("Impossible de charger la sauvegarde", e)
  }
}
// ------------------------------------------------

const clickPaperclip = () => {
  trombones.value += clickValue.value
  saveGame() 
}

const buyAutoClipper = () => {
  if (trombones.value >= autoClipperCost.value) {
    trombones.value -= autoClipperCost.value
    productionRate.value += 1
    autoClipperCost.value = Math.floor(autoClipperCost.value * 1.5)
    saveGame()
  }
}

setInterval(() => {
  if (productionRate.value > 0) {
    trombones.value += productionRate.value
  }
}, 1000)

const saveGame = async () => {
  try {
    await fetch('http://localhost:5000/api/save', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        trombones: trombones.value, 
        production_rate: productionRate.value 
      })
    })
    console.log("Partie sauvegardée !")
  } catch (e) {
    console.error("Erreur sauvegarde", e)
  }
}
</script>

<template>
  <div class="game-container">
    <h1 class="pixel-title">PAPERCLIP TYCOON</h1>
    
    <div class="stats-panel pixel-box">
      <p>Trombones: <span class="score">{{ trombones }}</span></p>
      <p>Par seconde: {{ productionRate }}</p>
    </div>

    <div class="click-zone">
      <button @click="clickPaperclip" class="pixel-btn clicker-btn">
        📎 FABRIQUER
      </button>
    </div>

    <div class="shop-panel pixel-box">
      <h2>BOUTIQUE</h2>
      <div class="upgrade">
        <p>Auto-Clipper (Coût: {{ autoClipperCost }})</p>
        <button 
          @click="buyAutoClipper" 
          class="pixel-btn upgrade-btn" 
          :disabled="trombones < autoClipperCost">
          ACHETER
        </button>
      </div>
    </div>
  </div>
</template>

<style>
/* Import de la police Pixel Art */
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');

body {
  background-color: #2c3e50;
  color: #ecf0f1;
  font-family: 'Press Start 2P', cursive; /* La police rétro */
  margin: 0;
  display: flex;
  justify-content: center;
  min-height: 100vh;
}

.game-container {
  text-align: center;
  padding: 20px;
  max-width: 600px;
}

.pixel-title {
  color: #f1c40f;
  text-shadow: 4px 4px #000;
  margin-bottom: 40px;
  font-size: 24px;
}

/* Effet boîte pixel art */
.pixel-box {
  background: #34495e;
  border: 4px solid #000;
  box-shadow: 8px 8px 0px #000;
  padding: 20px;
  margin-bottom: 20px;
  text-align: left;
}

.score {
  color: #2ecc71;
}

/* Boutons Pixel Art */
.pixel-btn {
  font-family: 'Press Start 2P', cursive;
  border: 4px solid #000;
  box-shadow: 4px 4px 0px #000;
  cursor: pointer;
  transition: transform 0.1s;
  outline: none;
}

.pixel-btn:active {
  transform: translate(4px, 4px);
  box-shadow: 0px 0px 0px #000;
}

.clicker-btn {
  background-color: #e74c3c;
  color: white;
  font-size: 20px;
  padding: 20px 40px;
  margin: 30px 0;
  width: 100%;
}

.upgrade-btn {
  background-color: #3498db;
  color: white;
  padding: 10px;
  font-size: 10px;
}

.upgrade-btn:disabled {
  background-color: #7f8c8d;
  cursor: not-allowed;
}

.upgrade {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
  font-size: 10px;
}
</style>