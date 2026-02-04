<template>
  <div class="greeting-container">
    <div class="greeting-content">
      <div class="avatar">👋</div>
      <h2>{{ greeting }}!</h2>
      <p class="message">{{ message }}</p>
      <button @click="changeGreeting" class="btn">
        Change Greeting
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const greetings = [
  { text: 'Hello', message: 'Welcome to the Greeting Module' },
  { text: 'Selamat Datang', message: 'Selamat datang di Modul Greeting' },
  { text: 'Bonjour', message: 'Bienvenue dans le module de salutation' },
  { text: 'Hola', message: 'Bienvenido al módulo de saludo' },
  { text: 'Konnichiwa', message: ' greetingモジュールへようこそ' },
]

const currentIndex = ref(0)

const greeting = computed(() => greetings[currentIndex.value].text)
const message = computed(() => greetings[currentIndex.value].message)

const changeGreeting = () => {
  currentIndex.value = (currentIndex.value + 1) % greetings.length
}
</script>

<style scoped>
.greeting-container {
  padding: 1rem;
}

.greeting-content {
  text-align: center;
}

.avatar {
  font-size: 4rem;
  margin-bottom: 1rem;
}

h2 {
  font-size: 2rem;
  color: #00dc82;
  margin-bottom: 0.5rem;
}

.message {
  color: #666;
  margin-bottom: 1.5rem;
  font-size: 1rem;
}

.btn {
  background: #00dc82;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.3s;
}

.btn:hover {
  background: #00c473;
}

.btn:active {
  transform: scale(0.98);
}
</style>
