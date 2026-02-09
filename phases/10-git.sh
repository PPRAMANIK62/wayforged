#!/usr/bin/env bash
# Phase 10: Git Configuration
# Installs git, copies configs, sets up global gitignore and SSH key (BOTH modes)

echo ">>> Installing git"
dnf_install git

echo ">>> Copying git configs"
copy_config "$CONFIGS_DIR/gitconfig" "$HOME/.gitconfig"

echo ">>> Setting up global gitignore"
ensure_dir "$HOME/.config/git"
copy_config "$CONFIGS_DIR/gitignore-global" "$HOME/.config/git/ignore"

echo ">>> Checking for SSH key"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ensure_dir "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "purbayanpramanik62@gmail.com" -f "$HOME/.ssh/id_ed25519" -N ""
  echo ">>> SSH key generated at ~/.ssh/id_ed25519"
  echo ">>> Add your public key to GitHub: cat ~/.ssh/id_ed25519.pub"
fi

echo ">>> Git configuration complete"
