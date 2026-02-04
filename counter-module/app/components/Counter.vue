<template>
  <div class="counter-container">
    <div class="counter-content">
      <div class="icon">🔢</div>
      <h2>Counter Module</h2>
      <div class="counter-display">
        <button @click="decrement" class="counter-btn" :disabled="count <= 0">
          -
        </button>
        <span class="count">{{ count }}</span>
        <button @click="increment" class="counter-btn">
          +
        </button>
      </div>
      <div class="stats">
        <p>Total clicks: {{ totalClicks }}</p>
        <button @click="reset" class="reset-btn">Reset</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
const totalClicks = ref(0)

const increment = () => {
  count.value++
  totalClicks.value++
}

const decrement = () => {
  if (count.value > 0) {
    count.value--
    totalClicks.value++
  }
}

const reset = () => {
  count.value = 0
}
</script>

<style scoped>
.counter-container {
  padding: 1rem;
}

.counter-content {
  text-align: center;
}

.icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

h2 {
  font-size: 2rem;
  color: #00dc82;
  margin-bottom: 1.5rem;
}

.counter-display {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.counter-btn {
  width: 50px;
  height: 50px;
  font-size: 1.5rem;
  border: 2px solid #00dc82;
  background: white;
  color: #00dc82;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.counter-btn:hover:not(:disabled) {
  background: #00dc82;
  color: white;
}

.counter-btn:active:not(:disabled) {
  transform: scale(0.95);
}

.counter-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.count {
  font-size: 3rem;
  font-weight: bold;
  color: #333;
  min-width: 80px;
}

.stats {
  background: #f5f5f5;
  padding: 1rem;
  border-radius: 8px;
}

.stats p {
  margin: 0 0 1rem 0;
  color: #666;
}

.reset-btn {
  background: #e74c3c;
  color: white;
  border: none;
  padding: 0.5rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.3s;
}

.reset-btn:hover {
  background: #c0392b;
}
</style>
