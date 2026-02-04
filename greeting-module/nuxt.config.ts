// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  future: {
    compatibilityVersion: 4,
  },

  ssr: false,

  srcDir: 'app',

  vite: {
    build: {
      target: 'esnext'
    }
  },

  hooks: {
    'vite:extendConfig': (viteInlineConfig, { isClient, isServer }) => {
      const { federation } = require('@module-federation/vite')

      viteInlineConfig.plugins = viteInlineConfig.plugins || []
      viteInlineConfig.plugins.push(
        federation({
          name: 'greeting',
          filename: 'remoteEntry.js',
          exposes: {
            './Greeting': './app/components/Greeting.vue',
          },
          shared: {
            vue: {
              requiredVersion: '^3.1.0',
              singleton: true,
            },
          },
        })
      )
    }
  }
})
