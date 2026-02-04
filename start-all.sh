#!/bin/bash
# Start all Module Federation servers

set -e

echo "🚀 Starting Module Federation servers..."
echo ""

# Kill any existing servers on these ports
echo "Cleaning up existing servers..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:3001 | xargs kill -9 2>/dev/null || true
lsof -ti:3002 | xargs kill -9 2>/dev/null || true

sleep 2

# Start greeting module
echo "Starting Greeting Module on port 3001..."
cd greeting-module
npx run preview > /tmp/greeting-serve.log 2>&1 &
GREETING_PID=$!
cd ..

# Start counter module
echo "Starting Counter Module on port 3002..."
cd counter-module
npx run preview > /tmp/counter-serve.log 2>&1 &
COUNTER_PID=$!
cd ..

# Start host
echo "Starting Host Application on port 3000..."
cd host
npx run preview > /tmp/host-serve.log 2>&1 &
HOST_PID=$!
cd ..

sleep 3

echo ""
echo "✨ All servers started!"
echo ""
echo "📍 URLs:"
echo "  - Greeting Module:  http://localhost:3001"
echo "  - Counter Module:   http://localhost:3002"
echo "  - Host Application: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all servers"
echo ""

# Wait for user interrupt
trap "echo ''; echo 'Stopping all servers...'; kill $GREETING_PID $COUNTER_PID $HOST_PID 2>/dev/null; exit 0" INT

# Keep script running
wait
