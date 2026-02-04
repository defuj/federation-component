#!/bin/bash
# Build all modules for Nuxt 4 with Module Federation

set -e

echo "🏗️  Building all modules with Nuxt 4..."

# Build greeting module
echo "Building greeting-module..."
cd greeting-module
pnpm run build
# Copy remoteEntry.js from build cache to public directory
cp node_modules/.cache/nuxt/.nuxt/dist/client/remoteEntry.js .output/public/
echo "✅ Greeting module built"
cd ..

# Build counter module
echo "Building counter-module..."
cd counter-module
pnpm run build
# Copy remoteEntry.js from build cache to public directory
cp node_modules/.cache/nuxt/.nuxt/dist/client/remoteEntry.js .output/public/
echo "✅ Counter module built"
cd ..

# Build host
echo "Building host..."
cd host
pnpm run build
echo "✅ Host built"
cd ..

echo ""
echo "✨ All modules built successfully with Nuxt 4!"
echo ""
echo "📝 Nuxt 4 notes:"
echo "  • Using new srcDir structure with app/ directory"
echo "  • remoteEntry.js needs manual copy (same as Nuxt 3)"
echo "  • Enhanced TypeScript support"
echo ""
echo "To start the application, run:"
echo "  ./start-all.sh"
