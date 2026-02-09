#!/usr/bin/env bash
# Phase 02: Hyprland + Wayland Stack
# Installs Hyprland compositor and all wayland components, copies configs

echo ">>> Installing Hyprland and Wayland components"
dnf_install hyprland hyprpaper hyprlock hypridle hyprshot \
  waybar swaync rofi-wayland \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  polkit-gnome nautilus loupe \
  wl-clipboard brightnessctl playerctl \
  NetworkManager network-manager-applet blueman \
  grim slurp

echo ">>> Copying Hyprland configs"
copy_config_dir "$CONFIGS_DIR/hypr" "$HOME/.config/hypr"

echo ">>> Copying Waybar configs"
copy_config_dir "$CONFIGS_DIR/waybar" "$HOME/.config/waybar"

echo ">>> Copying Rofi configs"
copy_config_dir "$CONFIGS_DIR/rofi" "$HOME/.config/rofi"

echo ">>> Installing custom scripts to ~/.local/bin"
ensure_dir "$HOME/.local/bin"
cp -f "$SCRIPTS_DIR/wifimenu" "$HOME/.local/bin/wifimenu"
cp -f "$SCRIPTS_DIR/powermenu" "$HOME/.local/bin/powermenu"
chmod +x "$HOME/.local/bin/wifimenu" "$HOME/.local/bin/powermenu"

echo ">>> Creating required directories"
ensure_dir "$HOME/Pictures/wallpapers" "$HOME/Pictures/Screenshots" "$HOME/.config/hypr/states"

echo ">>> Hyprland setup complete"
