#!/usr/bin/env bash
# Phase 11: Applications
# Installs Zen Browser (both modes), plus full-mode apps (VLC, OBS, etc.)

echo ">>> Installing Zen Browser"
flatpak install -y flathub app.zen_browser.zen

if [ "${WAYFORGED_MODE:-minimal}" = "full" ]; then
  echo ">>> Installing full mode applications..."

  # DNF apps
  dnf_install vlc obs-studio tmux

  # Slack (repo added in 01-repos.sh)
  dnf_install slack

  # Flatpak apps
  flatpak install -y flathub md.obsidian.Obsidian
  flatpak install -y flathub it.mijorus.gearlever
fi

echo ">>> Applications setup complete"
