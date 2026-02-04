<template>
  <div class="container">
    <h1>🔢 Counter Module</h1>
    <p class="subtitle">Standalone Web Component - Independent state management!</p>

    <div class="demo">
      <counter-component></counter-component>
    </div>

    <div class="info">
      <h3>Web Component Details</h3>
      <ul>
        <li><strong>Tag:</strong> <code>&lt;counter-component&gt;</code></li>
        <li><strong>Script:</strong> <code>/counter-component.js</code></li>
        <li><strong>Status:</strong> ✅ Ready for remote loading</li>
        <li><strong>State:</strong> Fully isolated per instance</li>
      </ul>
    </div>

    <div class="usage">
      <h3>How to Use in Other Apps:</h3>
      <pre><code>&lt;script src="http://localhost:3002/counter-component.js"&gt;&lt;/script&gt;
&lt;counter-component&gt;&lt;/counter-component&gt;</code></pre>
    </div>
  </div>
</template>

<script setup lang="ts">
// Load the Web Component
onMounted(() => {
  const script = document.createElement('script')
  script.src = '/counter-component.js'
  document.head.appendChild(script)
})

useHead({
  title: 'Counter Module - Web Component',
})
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
  font-family: system-ui, -apple-system, sans-serif;
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

.demo {
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  padding: 2rem;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
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
}

.info ul {
  list-style: none;
  padding: 0;
}

.info li {
  padding: 0.5rem 0;
  font-size: 1rem;
}

code {
  background: #fff;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-family: monospace;
  color: #00dc82;
}

.usage {
  background: #2d2d2d;
  padding: 1.5rem;
  border-radius: 8px;
}

.usage h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #fff;
}

.usage pre {
  margin: 0;
}

.usage code {
  background: transparent;
  color: #f8f8f2;
  display: block;
  padding: 1rem;
}
</style>
