#!/usr/bin/env bash
# Phase 03: Tokyo Night GTK Theme
# Installs Tokyonight-Dark GTK theme, copies GTK configs, applies gsettings

echo ">>> Installing Tokyonight-Dark GTK theme"
THEME_DIR="$HOME/.themes"
ensure_dir "$THEME_DIR"

if [ ! -d "$THEME_DIR/Tokyonight-Dark" ]; then
  git clone --depth=1 https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git /tmp/tokyo-night-gtk
  cp -r /tmp/tokyo-night-gtk/themes/Tokyonight-Dark "$THEME_DIR/"
  rm -rf /tmp/tokyo-night-gtk
  echo "  Installed Tokyonight-Dark theme"
else
  echo "  Tokyonight-Dark theme already installed"
fi

echo ">>> Copying GTK configuration files"
copy_config "$CONFIGS_DIR/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
copy_config "$CONFIGS_DIR/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
copy_config "$CONFIGS_DIR/gtkrc-2.0" "$HOME/.gtkrc-2.0"

echo ">>> Applying dark mode via gsettings"
if command_exists gsettings; then
  gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
  gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
  gsettings set org.gnome.desktop.interface cursor-size 24
  echo "  Applied gsettings"
else
  echo "  gsettings not available, skipping"
fi

echo ">>> Copying Xresources"
copy_config "$CONFIGS_DIR/Xresources" "$HOME/.Xresources"

echo ">>> Theme setup complete"
