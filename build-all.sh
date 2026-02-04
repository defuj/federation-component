#!/bin/bash
# Build all modules and prepare for Module Federation

set -e

echo "🏗️  Building all modules..."

# Build greeting module
echo "Building greeting-module..."
cd greeting-module
pnpm run build
cp node_modules/.cache/nuxt/.nuxt/dist/client/remoteEntry.js .output/public/
echo "✅ Greeting module built"
cd ..

# Build counter module
echo "Building counter-module..."
cd counter-module
pnpm run build
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
echo "✨ All modules built successfully!"
echo ""
echo "To start the application, run:"
echo "  ./start-all.sh"
