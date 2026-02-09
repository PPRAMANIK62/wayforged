#!/usr/bin/env bash
# Phase 09: Editors
# Installs Neovim (bare) and Zed editor with configs (BOTH modes)

echo ">>> Installing Neovim"
dnf_install neovim
ensure_dir "$HOME/.config/nvim"

echo ">>> Installing Zed editor"
if ! command_exists zed; then
  curl -fsSL https://zed.dev/install.sh | sh
fi

echo ">>> Copying Zed configs"
copy_config_dir "$CONFIGS_DIR/zed" "$HOME/.config/zed"

echo ">>> Editors setup complete"
