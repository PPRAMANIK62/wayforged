#!/usr/bin/env bash
# Phase 05: Ghostty Terminal
# Installs Ghostty from COPR and copies config

echo ">>> Installing Ghostty terminal"
dnf_install ghostty

echo ">>> Copying Ghostty config"
copy_config_dir "$CONFIGS_DIR/ghostty" "$HOME/.config/ghostty"

echo ">>> Ghostty setup complete"
