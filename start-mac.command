#!/bin/bash
cd "$(dirname "$0")"
if ! command -v npm >/dev/null 2>&1; then
  echo "Node.js/npm is required. Install Node.js from https://nodejs.org/"
  read -r -p "Press Enter to exit..."
  exit 1
fi
if [ ! -d node_modules ]; then npm install || exit 1; fi
npm run dev
