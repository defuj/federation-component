# Module Federation with Nuxt 4 & @module-federation/vite

Production-ready micro-frontend architecture using **Module Federation** with Nuxt 4, Vue 3, and Vite.

## ✨ What This Achieves

This is **TRUE Module Federation** - not iframes, not Web Components, but genuine runtime module loading with:

- ✅ Remote Vue components loaded at runtime
- ✅ Shared dependencies (Vue singleton)
- ✅ Independent deployment & versioning
- ✅ TypeScript support
- ✅ Production-ready builds
- ✅ **Nuxt 4** with new `app/` directory structure

**⚠️ IMPORTANT**: Module Federation with Nuxt 4 works in **production builds only**, not in development mode. The `remoteEntry.js` file is generated during build, not during development.

**🚀 Nuxt 4 Improvements**:
- ✓ `remoteEntry.js` automatically copied to `.output/public` (no manual copy needed!)
- ✓ Better `srcDir` organization with `app/` directory
- ✓ Enhanced TypeScript support
- ✓ Improved build performance

## Architecture

```
┌─────────────────────────────────────────────────┐
│           Host Application (port 3000)           │
│  nuxt.config.ts:                                │
│  - remotes: {                                   │
│      greeting: 'greeting@localhost:3001',       │
│      counter: 'counter@localhost:3002'          │
│    }                                            │
│                                                  │
│  pages/index.vue:                                │
│  - import('greeting/Greeting')                   │
│  - import('counter/Counter')                     │
└─────────────────────────────────────────────────┘
                    │
                    │ loads remoteEntry.js at runtime
                    │
    ┌───────────────┴───────────────┐
    │                               │
┌───▼────────┐              ┌───────▼───┐
│  Greeting  │              │  Counter  │
│  (port 3001)│              │  (port 3002)│
│            │              │            │
│ exposes:   │              │ exposes:   │
│ ./Greeting │              │ ./Counter  │
└────────────┘              └────────────┘
```

## Project Structure (Nuxt 4)

```
federation-component/
├── host/                         # Host/shell application
│   ├── nuxt.config.ts            # ✅ Module Federation config (srcDir: 'app')
│   ├── app/                      # Nuxt 4 source directory
│   │   ├── pages/
│   │   │   └── index.vue         # Dynamic import of remote components
│   │   └── app.vue               # Root component
│   └── ...
├── greeting-module/              # Remote module 1
│   ├── nuxt.config.ts            # ✅ Module Federation config (srcDir: 'app')
│   ├── app/                      # Nuxt 4 source directory
│   │   ├── components/
│   │   │   └── Greeting.vue      # Exposed component
│   │   └── app.vue               # Root component
│   └── ...
├── counter-module/               # Remote module 2
│   ├── nuxt.config.ts            # ✅ Module Federation config (srcDir: 'app')
│   ├── app/                      # Nuxt 4 source directory
│   │   ├── components/
│   │   │   └── Counter.vue       # Exposed component
│   │   └── app.vue               # Root component
│   └── ...
├── package.json                  # Root workspace config
├── pnpm-workspace.yaml
├── build-all.sh                  # Build helper script
└── start-all.sh                  # Start helper script
```

**Key Changes in Nuxt 4**:
- All application files now in `app/` directory
- `srcDir: 'app'` explicitly set in `nuxt.config.ts`
- Exposes paths use `./app/components/ComponentName.vue`
- `remoteEntry.js` automatically copied to `.output/public/`

## The Secret Sauce

### Key Configuration (host/nuxt.config.ts)

```typescript
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  future: {
    compatibilityVersion: 4,
  },

  ssr: false,

  srcDir: 'app',  // Nuxt 4: Explicitly set source directory

  vite: {
    build: {
      target: 'esnext'
    }
  },

  hooks: {
    'vite:extendConfig': (viteInlineConfig) => {
      const { federation } = require('@module-federation/vite')

      viteInlineConfig.plugins = viteInlineConfig.plugins || []
      viteInlineConfig.plugins.push(
        federation({
          name: 'host',
          remotes: {
            greeting: 'greeting@http://localhost:3001/remoteEntry.js',
            counter: 'counter@http://localhost:3002/remoteEntry.js',
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
```

### Remote Module Configuration (greeting-module/nuxt.config.ts)

```typescript
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  future: {
    compatibilityVersion: 4,
  },

  ssr: false,

  srcDir: 'app',  // Nuxt 4: Explicitly set source directory

  vite: {
    build: {
      target: 'esnext'
    }
  },

  hooks: {
    'vite:extendConfig': (viteInlineConfig) => {
      const { federation } = require('@module-federation/vite')

      viteInlineConfig.plugins = viteInlineConfig.plugins || []
      viteInlineConfig.plugins.push(
        federation({
          name: 'greeting',
          filename: 'remoteEntry.js',
          exposes: {
            './Greeting': './app/components/Greeting.vue',  // Note: ./app/ prefix
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
```

## Usage in Host Application

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

// ✅ Import remote components using Module Federation
const GreetingComponent = defineAsyncComponent({
  loader: () => import('greeting/Greeting'),
  timeout: 10000,
})

const CounterComponent = defineAsyncComponent({
  loader: () => import('counter/Counter'),
  timeout: 10000,
})
</script>

<template>
  <div>
    <GreetingComponent />
    <CounterComponent />
  </div>
</template>
```

## Getting Started

### Prerequisites

- Node.js 18+
- pnpm 8+

### Installation

```bash
pnpm install
```

### Development

**⚠️ Important**: Module Federation does not work in Nuxt development mode. You must build and serve production artifacts.

```bash
# Build all modules
pnpm build
```

### Running the Application

Since Module Federation requires production builds, use static file servers:

```bash
# Terminal 1: Serve Greeting Module
cd greeting-module
npx serve .output/public -p 3001

# Terminal 2: Serve Counter Module
cd ../counter-module
npx serve .output/public -p 3002

# Terminal 3: Serve Host Application
cd ../host
npx serve .output/public -p 3000
```

Then open http://localhost:3000 to see Module Federation in action.

### Quick Start

The easiest way to build and run all modules:

```bash
# Build all modules and copy remoteEntry.js files
pnpm build:all

# Start all static servers
pnpm start
```

Then open http://localhost:3000

**Note**: This will:
1. Build all three applications (host, greeting, counter)
2. Copy `remoteEntry.js` to each `.output/public` directory
3. Start static file servers on ports 3001, 3002, and 3000
4. Keep all servers running until you press Ctrl+C

## Key Features

### ✅ Runtime Loading

Components are loaded at runtime without rebuilding the host application.

### ✅ Shared Dependencies

Vue is shared as a singleton across all modules to reduce bundle size.

### ✅ Independent Deployment

Each module can be deployed independently without affecting other modules or the host.

### ✅ TypeScript Support

Full TypeScript support with proper type definitions.

### ⚠️ Production Build Required

Module Federation with Nuxt 3 **only works with production builds**:

- The `remoteEntry.js` file is generated during `pnpm build`
- Development mode (`pnpm dev`) will NOT generate the federation manifest
- You must serve built artifacts using a static file server
- Nitro server (Nuxt's default server) does not properly serve `remoteEntry.js`

**Why?** Module Federation's Vite plugin generates the federation manifest during the production build phase. Nuxt's development server doesn't invoke this plugin in the same way.

## Critical Implementation Details (Nuxt 4)

### 1. Set srcDir to 'app'

**Required** for Nuxt 4 with Module Federation:

```typescript
export default defineNuxtConfig({
  srcDir: 'app',  // Critical: Points to app/ directory
  // ...
})
```

### 2. Disable SSR

```typescript
export default defineNuxtConfig({
  ssr: false,  // Required for Module Federation
  // ...
})
```

### 3. Use Exposes Path with 'app/' Prefix

For remote modules, the exposes path must include the `app/` directory:

```typescript
exposes: {
  './Greeting': './app/components/Greeting.vue',  // Note: ./app/ prefix required
}
```

### 4. Use `vite:extendConfig` Hook

❌ **DON'T** do this (doesn't work):
```typescript
import federation from '@module-federation/vite'

export default defineNuxtConfig({
  vite: {
    plugins: [federation({ ... })]
  }
})
```

✅ **DO** this:
```typescript
export default defineNuxtConfig({
  hooks: {
    'vite:extendConfig': (viteInlineConfig) => {
      const { federation } = require('@module-federation/vite')
      viteInlineConfig.plugins = viteInlineConfig.plugins || []
      viteInlineConfig.plugins.push(federation({ ... }))
    }
  }
})
```

### 5. Copy remoteEntry.js After Build

Nuxt 4 generates `remoteEntry.js` in the build cache but doesn't automatically copy it to `.output/public/`. You still need to copy it manually:

```bash
# From each remote module directory
cp node_modules/.cache/nuxt/.nuxt/dist/client/remoteEntry.js .output/public/
```

The `build-all.sh` script handles this automatically.

### 6. Use Static File Server

Nitro server doesn't properly serve `remoteEntry.js`. Use a static file server:

```bash
npx serve .output/public -p 3001
```

## Common Issues & Solutions

### Issue: "federation.default is not a function"

**Solution**: Use named export: `const { federation } = require('@module-federation/vite')`

### Issue: remoteEntry.js not found (404)

**Symptoms**: Request to `/remoteEntry.js` returns HTML or 404 error

**Causes**:
1. Trying to use development mode instead of production build
2. Nitro server not serving the file correctly

**Solution**:
1. Build the application: `pnpm build`
2. Use static file server: `npx serve .output/public -p 3001`
3. **Nuxt 4**: File automatically copied to `.output/public/` ✓

### Issue: Could not resolve component path

**Symptoms**: `Could not resolve "./components/Counter.vue" from "virtual:mf-exposes"`

**Cause**: Wrong path in `exposes` configuration

**Solution**: Use `./app/components/ComponentName.vue` path with `app/` prefix:
```typescript
exposes: {
  './Counter': './app/components/Counter.vue',  // ✓ Correct
}
```

### Issue: TypeScript errors about remote imports

**Solution**: These are warnings and can be safely ignored. The types will download at runtime.

### Issue: CORS errors in production

**Solution**: Configure CORS in your remote modules' server config.

## Building for Production

```bash
pnpm build
```

Each application builds to its own `.output` directory with optimized Module Federation configuration.

## Deployment

### Option 1: Same Domain

Deploy all modules to the same domain with different paths:
- Host: `/`
- Greeting: `/greeting/`
- Counter: `/counter/`

Update remote URLs in production:
```typescript
remotes: {
  greeting: 'greeting@https://app.example.com/greeting/remoteEntry.js',
  counter: 'counter@https://app.example.com/counter/remoteEntry.js',
}
```

### Option 2: Different Domains

Deploy each module to its own domain:
- Host: `https://app.example.com`
- Greeting: `https://greeting.example.com`
- Counter: `https://counter.example.com`

## Versioning Strategy

With Module Federation, you can:
- Deploy multiple versions of the same module
- Run A/B tests with different versions
- Rollback to previous versions instantly

```typescript
remotes: {
  greeting: 'greeting@https://cdn.example.com/greeting-v1@1.2.0/remoteEntry.js',
  counterV2: 'counterV2@https://cdn.example.com/counter-v2@2.0.0/remoteEntry.js',
}
```

## Performance Benefits

### Shared Dependencies

- ✅ Vue is loaded once (singleton)
- ✅ Smaller bundle sizes
- ✅ Faster initial load

### Lazy Loading

- ✅ Modules load only when needed
- ✅ Parallel loading of remote modules
- ✅ Caching of remoteEntry.js files

## Comparison with Other Approaches

| Feature | Module Federation | Iframes | Web Components | Nuxt Layers |
|----------|------------------|---------|----------------|-------------|
| Runtime Loading | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No |
| Shared Dependencies | ✅ Yes | ❌ No | ❌ No | ✅ Yes |
| Framework Native | ✅ Yes | ❌ No | ⚠️ Partial | ✅ Yes |
| TypeScript Support | ✅ Yes | ✅ Yes | ⚠️ Complex | ✅ Yes |
| Development Experience | ✅ Excellent | ⚠️ Isolated | ⚠️ Complex | ✅ Excellent |
| Build-time Sharing | ❌ No | ❌ No | ❌ No | ✅ Yes |

## Advanced Usage

### Multiple Versions of the Same Component

```typescript
remotes: {
  greetingV1: 'greetingV1@https://cdn.example.com/v1/remoteEntry.js',
  greetingV2: 'greetingV2@https://cdn.example.com/v2/remoteEntry.js',
}
```

### Dynamic Remote URLs

```typescript
const remoteUrl = process.env.NODE_ENV === 'production'
  ? 'https://cdn.example.com/greeting/remoteEntry.js'
  : 'http://localhost:3001/remoteEntry.js'

remotes: {
  greeting: `greeting@${remoteUrl}`,
}
```

### Shared Libraries Beyond Vue

```typescript
shared: {
  vue: { singleton: true },
  'vue-router': { singleton: true },
  pinia: { singleton: true },
  '@my-org/ui-lib': { singleton: true },
}
```

## Troubleshooting

### Module Not Loading

1. Check browser console for errors
2. Verify remoteEntry.js is accessible: `curl http://localhost:3001/remoteEntry.js`
3. Check network tab for failed requests
4. Ensure remote modules are running

### Version Conflicts

If you see version conflict warnings:
```typescript
shared: {
  vue: {
    requiredVersion: '^3.1.0',
    singleton: true,
    strictVersion: false, // Allow semver compatible versions
  },
}
```

### Type Errors

TypeScript errors about remote modules are expected during development. The types are downloaded at runtime and will be resolved.

## Resources

- [@module-federation/vite Documentation](https://www.npmjs.com/package/@module-federation/vite)
- [Module Federation Guide](https://module-federation.io/)
- [Nuxt 3 Documentation](https://nuxt.com/)
- [Vite Documentation](https://vitejs.dev/)

## Credits

This implementation successfully integrates @module-federation/vite with Nuxt 3 using:
- ✅ `vite:extendConfig` hook
- ✅ Named exports from CommonJS module
- ✅ Client-side only plugin application

## License

MIT
