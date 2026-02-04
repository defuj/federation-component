<template>
  <div class="container">
    <h1>🚀 Module Federation with Nuxt 3</h1>
    <p class="subtitle">True remote components using @module-federation/vite</p>

    <div class="loading" v-if="loading">Loading remote modules...</div>

    <div class="modules-grid" v-else>
      <div class="module-card">
        <h2>👋 Greeting Module</h2>
        <p class="module-info">Remote: http://localhost:3001</p>
        <div class="module-content">
          <GreetingComponent v-if="greetingLoaded" />
          <div v-else class="error">Failed to load Greeting module</div>
        </div>
      </div>

      <div class="module-card">
        <h2>🔢 Counter Module</h2>
        <p class="module-info">Remote: http://localhost:3002</p>
        <div class="module-content">
          <CounterComponent v-if="counterLoaded" />
          <div v-else class="error">Failed to load Counter module</div>
        </div>
      </div>
    </div>

    <div class="info">
      <h3>✨ Module Federation Architecture</h3>
      <ul>
        <li>✅ True remote components (loaded via Module Federation)</li>
        <li>✅ Runtime dynamic loading (no rebuild needed)</li>
        <li>✅ Shared dependencies (Vue singleton)</li>
        <li>✅ Independent deployment & versioning</li>
        <li>✅ TypeScript support</li>
      </ul>
      <div class="urls">
        <p>
          <strong>Greeting Remote:</strong> http://localhost:3001/remoteEntry.js
        </p>
        <p>
          <strong>Counter Remote:</strong> http://localhost:3002/remoteEntry.js
        </p>
      </div>
    </div>

    <div class="note">
      <h4>💡 How It Works:</h4>
      <ol>
        <li>Each remote module exposes components via Module Federation</li>
        <li>Host app imports remote components using dynamic imports</li>
        <li>Vite loads remoteEntry.js from each module at runtime</li>
        <li>Components are bundled with shared Vue dependency</li>
      </ol>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, onMounted } from "vue";

const loading = ref(true);
const greetingLoaded = ref(false);
const counterLoaded = ref(false);

// Load remote components using Module Federation
const GreetingComponent = defineAsyncComponent({
  loader: () => {
    return import("greeting/Greeting")
      .then((m) => {
        greetingLoaded.value = true;
        return m.default || m;
      })
      .catch((err) => {
        console.error("Failed to load Greeting module:", err);
        return {
          template: '<div class="error">Failed to load Greeting module</div>',
        };
      });
  },
  timeout: 10000,
});

const CounterComponent = defineAsyncComponent({
  loader: () => {
    return import("counter/Counter")
      .then((m) => {
        counterLoaded.value = true;
        return m.default || m;
      })
      .catch((err) => {
        console.error("Failed to load Counter module:", err);
        return {
          template: '<div class="error">Failed to load Counter module</div>',
        };
      });
  },
  timeout: 10000,
});

onMounted(() => {
  // Hide loading state after a delay to allow async components to load
  setTimeout(() => {
    loading.value = false;
  }, 1000);
});

useHead({
  title: "Module Federation - Nuxt 3",
});
</script>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  font-family:
    system-ui,
    -apple-system,
    sans-serif;
}

h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: #00dc82;
}

.subtitle {
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 2rem;
}

.loading {
  text-align: center;
  padding: 3rem;
  font-size: 1.2rem;
  color: #666;
}

.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.module-card {
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  padding: 1.5rem;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.module-card h2 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  font-size: 1.5rem;
}

.module-info {
  font-size: 0.85rem;
  color: #888;
  margin-bottom: 1rem;
  font-family: monospace;
  background: #f5f5f5;
  padding: 0.5rem;
  border-radius: 4px;
}

.module-content {
  min-height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.error {
  color: #e74c3c;
  padding: 1rem;
  background: #fee;
  border-radius: 4px;
  text-align: center;
}

.info {
  background: #f5f5f5;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.info h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #00dc82;
}

.info ul {
  list-style: none;
  padding: 0;
  margin-bottom: 1rem;
}

.info li {
  padding: 0.5rem 0;
  font-size: 1rem;
}

.urls {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #ddd;
}

.urls p {
  margin: 0.5rem 0;
  font-size: 0.9rem;
  font-family: monospace;
}

.note {
  background: #e3f2fd;
  border-left: 4px solid #2196f3;
  padding: 1.5rem;
  border-radius: 8px;
}

.note h4 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #1976d2;
}

.note ol {
  margin: 0;
  padding-left: 1.5rem;
}

.note li {
  margin-bottom: 0.5rem;
  line-height: 1.6;
}
</style>
