#!/usr/bin/env bash
# Phase 04: Nerd Fonts
# Installs JetBrains Mono (DNF), JetBrains Mono NF, Iosevka NF from GitHub

echo ">>> Installing JetBrains Mono from DNF"
dnf_install jetbrains-mono-fonts-all

FONT_DIR="$HOME/.local/share/fonts"
ensure_dir "$FONT_DIR"

echo ">>> Installing JetBrains Mono Nerd Font"
if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
  JBNF_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
  curl -fsSL "$JBNF_URL" -o /tmp/JetBrainsMono.tar.xz
  mkdir -p /tmp/JetBrainsMono
  tar -xf /tmp/JetBrainsMono.tar.xz -C /tmp/JetBrainsMono
  cp /tmp/JetBrainsMono/*.ttf "$FONT_DIR/" 2>/dev/null || true
  rm -rf /tmp/JetBrainsMono /tmp/JetBrainsMono.tar.xz
  echo "  Installed JetBrains Mono Nerd Font"
else
  echo "  JetBrains Mono Nerd Font already installed"
fi

echo ">>> Installing Iosevka Nerd Font"
if ! fc-list | grep -qi "Iosevka Nerd"; then
  IOSEVKA_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.tar.xz"
  curl -fsSL "$IOSEVKA_URL" -o /tmp/Iosevka.tar.xz
  mkdir -p /tmp/Iosevka
  tar -xf /tmp/Iosevka.tar.xz -C /tmp/Iosevka
  cp /tmp/Iosevka/*.ttf "$FONT_DIR/" 2>/dev/null || true
  rm -rf /tmp/Iosevka /tmp/Iosevka.tar.xz
  echo "  Installed Iosevka Nerd Font"
else
  echo "  Iosevka Nerd Font already installed"
fi

echo ">>> Rebuilding font cache"
fc-cache -fv

echo ">>> Font installation complete"
