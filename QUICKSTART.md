# Quick Start Guide

## Step 1: Install Dependencies
```bash
pnpm install
```

## Step 2: Start Applications

You need to open 3 terminal windows:

### Terminal 1 - Greeting Module
```bash
pnpm dev:greeting
```
Will start on http://localhost:3001

### Terminal 2 - Counter Module
```bash
pnpm dev:counter
```
Will start on http://localhost:3002

### Terminal 3 - Host Application
```bash
pnpm dev:host
```
Will start on http://localhost:3000

## Step 3: View Your Micro-frontend

Open http://localhost:3000 in your browser. You should see:
- ✅ Host application loaded
- ✅ Greeting module loaded dynamically
- ✅ Counter module loaded dynamically

## Testing Individual Modules

You can also visit each module independently:
- Greeting: http://localhost:3001
- Counter: http://localhost:3002

## Troubleshooting

If modules don't load in the host:
1. Ensure both greeting and counter modules are running
2. Check browser console for errors
3. Verify ports 3001 and 3002 are accessible

## Next Steps

- Modify components in each module
- Add new remote modules
- Configure shared dependencies
- Set up production builds
