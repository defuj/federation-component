# Module Federation dengan Nuxt 3 - Working Setup

## 🔑 Temuan Kunci

Setelah banyak eksperimen, ditemukan bahwa **@module-federation/vite hanya berfungsi dengan production builds**, bukan di development mode.

## Mengapa Development Mode Tidak Berfungsi?

1. **Plugin Vite**: @module-federation/vite adalah plugin Vite yang menghasilkan `remoteEntry.js` selama build production
2. **Nuxt Dev Server**: Development server Nuxt tidak menjalankan plugin dengan cara yang sama
3. **Nitro Server**: Server Nitro bawaan Nuxt tidak melayani `remoteEntry.js` dengan benar

## Setup yang Berfungsi

### 1. Konfigurasi Nuxt

**Setiap module harus:**
- Menonaktifkan SSR: `ssr: false`
- Menggunakan `vite:extendConfig` hook
- Menggunakan named export: `const { federation } = require(...)`

### 2. Workflow Build & Deploy

```bash
# Build semua module
pnpm build:all

# Start semua server
pnpm start
```

### 3. File remoteEntry.js

File ini dihasilkan di:
- Sumber: `node_modules/.cache/nuxt/.nuxt/dist/client/remoteEntry.js`
- Tujuan: `.output/public/remoteEntry.js`

**Otomatis dicopy oleh** `build-all.sh`

### 4. Static Server

Gunakan `serve` (bukan Nitro server):
```bash
npx serve .output/public -p 3001
```

## Arsitektur Production

```
┌─────────────────────────────────────────┐
│         Static File Servers              │
│  (serve .output/public directories)      │
└─────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
    Port 3001   Port 3002   Port 3000
    Greeting    Counter      Host
    Module      Module     Application
```

## Files Kunci

1. **build-all.sh** - Build dan copy remoteEntry.js
2. **start-all.sh** - Start semua static servers
3. **nuxt.config.ts** (setiap module) - Konfigurasi Module Federation
4. **package.json** - Scripts untuk build:all dan start

## Testing

1. Build: `./build-all.sh` atau `pnpm build:all`
2. Start: `./start-all.sh` atau `pnpm start`
3. Buka: http://localhost:3000
4. Verifikasi:
   - Greeting component muncul
   - Counter component muncul
   - Tidak ada error di console browser

## Troubleshooting

### Error: "federation.default is not a function"
- ✅ Gunakan named export: `const { federation } = require(...)`

### Error: 404 pada /remoteEntry.js
- ✅ Pastikan sudah di-build: `pnpm build`
- ✅ Pastikan file dicopy ke `.output/public/`
- ✅ Gunakan static server, bukan Nitro server

### Error: Vue Router warning
- ✅ Normal untuk production builds
- ✅ Tidak berfungsi di development mode

## Deployment

Untuk production:

1. Build semua modules
2. Deploy `.output/public` ke static hosting:
   - Vercel
   - Netlify
   - AWS S3 + CloudFront
   - Nginx/Apache

3. Update remote URLs di host:
```typescript
remotes: {
  greeting: 'greeting@https://cdn.example.com/greeting/remoteEntry.js',
  counter: 'counter@https://cdn.example.com/counter/remoteEntry.js',
}
```

## Kesimpulan

Module Federation dengan Nuxt 3 **memungkinkan**, tetapi:
- ✅ Hanya bekerja dengan production builds
- ✅ Memerlukan static file servers
- ✅ Memerlukan setup tambahan (copy remoteEntry.js)
- ❌ Tidak support development mode dengan hot reload

Trade-off yang diterima untuk:
- ✅ True runtime module loading
- ✅ Independent deployment
- ✅ Shared dependencies
- ✅ Type safety
