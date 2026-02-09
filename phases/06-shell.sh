#!/usr/bin/env bash
# Phase 06: Zsh + Oh My Zsh + Plugins
# Installs zsh, oh-my-zsh, plugins, copies .zshrc, changes default shell

echo ">>> Installing Zsh"
dnf_install zsh

echo ">>> Installing Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "  Installed Oh My Zsh"
else
  echo "  Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo ">>> Installing zsh-autosuggestions"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

echo ">>> Installing zsh-completions"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

echo ">>> Installing zsh-syntax-highlighting"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo ">>> Copying .zshrc"
copy_config "$CONFIGS_DIR/zshrc" "$HOME/.zshrc"

echo ">>> Setting Zsh as default shell"
if [ "$SHELL" != "$(which zsh)" ]; then
  sudo chsh -s "$(which zsh)" "$USER"
  echo "  Default shell changed to zsh"
else
  echo "  Zsh is already default shell"
fi

echo ">>> Shell setup complete"
