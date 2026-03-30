<template>
  <div class="game-bonus-panel">
    <h2 class="pixel-title">TALENTS</h2>
    
    <div class="bonus-section" v-if="activeBonuses.length > 0">
      <h3>ACTIFS</h3>
      <div class="bonus-list">
        <div class="bonus-item active" v-for="bonus in activeBonuses" :key="bonus.id">
          <span class="bonus-emoji">{{ bonus.emoji }}</span>
          <div class="bonus-text">
            <div class="b-name">{{ bonus.name }}</div>
            <div class="b-desc">{{ bonus.desc }}</div>
          </div>
          <span class="check-mark">✔️</span>
        </div>
      </div>
    </div>

    <div class="bonus-section mt-big">
      <h3>RECHERCHE</h3>
      <div class="bonus-list">
        <div class="bonus-item purchasable" v-for="bonus in availableBonuses" :key="bonus.id">
          <span class="bonus-emoji">{{ bonus.emoji }}</span>
          <div class="bonus-text">
            <div class="b-name">{{ bonus.name }}</div>
            <div class="b-desc">{{ bonus.desc }}</div>
          </div>
          <button 
            class="btn-bonus-buy" 
            :disabled="population < bonus.cost"
            @click="$emit('buy', bonus.id)"
          >
            {{ formatNumber(bonus.cost) }}
          </button>
        </div>
        <div v-if="availableBonuses.length === 0" class="all-unlocked">
          Tous les talents sont débloqués ! 🎉
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { BONUSES } from '../config/bonuses'

const props = defineProps({
  population: { type: Number, required: true },
  acquiredBonuses: { type: Array, required: true }
})

defineEmits(['buy'])

const activeBonuses = computed(() => {
  return BONUSES.filter(b => props.acquiredBonuses.includes(b.id))
})

const availableBonuses = computed(() => {
  return BONUSES.filter(b => !props.acquiredBonuses.includes(b.id))
})

const formatNumber = (num) => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'k'
  return num
}
</script>

<style scoped>
/* Scoped styles specific to the bonus panel interior */
.bonus-section h3 {
  font-size: 14px;
  color: #cba8f0;
  border-bottom: 2px solid #5a3d7a;
  padding-bottom: 5px;
  margin-bottom: 15px;
}

.mt-big {
  margin-top: 30px;
}

.bonus-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.bonus-item {
  display: flex;
  align-items: center;
  background: rgba(43, 25, 61, 0.8);
  border: 2px solid #5a3d7a;
  padding: 8px;
  gap: 10px;
  border-radius: 4px;
}

.bonus-item.active {
  border-color: #8e44ad;
  background: rgba(62, 28, 92, 0.9);
  box-shadow: 0 0 10px rgba(142, 68, 173, 0.5);
}

.bonus-item.purchasable:hover {
  border-color: #9b59b6;
  transform: translateX(-2px);
  transition: all 0.2s ease;
}

.bonus-emoji {
  font-size: 24px;
  min-width: 30px;
  text-align: center;
}

.bonus-text {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.b-name {
  font-size: 10px;
  font-weight: bold;
  color: #fff;
  margin-bottom: 4px;
}

.b-desc {
  font-size: 8px;
  color: #bdc3c7;
  line-height: 1.4;
}

.check-mark {
  color: #2ecc71;
  font-size: 16px;
}

.btn-bonus-buy {
  background: #8e44ad;
  color: white;
  border: 2px solid #000;
  padding: 8px;
  font-family: inherit;
  font-size: 8px;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.2s ease;
}

.btn-bonus-buy:not(:disabled):hover {
  background: #9b59b6;
  transform: scale(1.05);
  box-shadow: 0 0 8px rgba(155, 89, 182, 0.8);
}

.btn-bonus-buy:disabled {
  background: #555;
  cursor: not-allowed;
  opacity: 0.5;
}

.all-unlocked {
  text-align: center;
  font-size: 10px;
  color: #f1c40f;
  margin-top: 20px;
  padding: 10px;
  border: 1px dashed #f1c40f;
}
</style>
