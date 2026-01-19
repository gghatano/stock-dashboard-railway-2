#!/bin/bash
set -e

echo "=== Building Stock Dashboard ==="

# Install Node.js dependencies and build frontend
echo "Building frontend..."
cd frontend
npm ci
npm run build
cd ..

# Install Python dependencies
echo "Installing Python dependencies..."
cd backend
python -m pip install -r requirements.txt
cd ..

echo "=== Build complete ==="
