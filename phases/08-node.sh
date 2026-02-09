#!/usr/bin/env bash
# Phase 08: Node.js Ecosystem
# Installs NVM, Node.js, corepack/pnpm, Bun, and npm globals (BOTH modes)

echo ">>> Installing NVM"
if [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Source NVM for this session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo ">>> Installing Node.js v24"
nvm install 24
nvm use 24
nvm alias default 24

echo ">>> Enabling corepack and pnpm"
corepack enable
corepack prepare pnpm@latest --activate

echo ">>> Installing Bun"
if ! command_exists bun; then
  curl -fsSL https://bun.sh/install | bash
fi

echo ">>> Installing npm global packages"
npm install -g typescript opencode-ai

if [ "${WAYFORGED_MODE:-minimal}" = "full" ]; then
  echo ">>> Installing typescript-language-server (full mode)"
  npm install -g typescript-language-server
fi

echo ">>> Node.js ecosystem setup complete"
