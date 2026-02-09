#!/usr/bin/env bash
# Phase 14: Final Setup
# Creates common directories, copies mimeapps, prints reminders (BOTH modes)

echo ">>> Finalizing setup..."

echo ">>> Creating common directories"
ensure_dir "$HOME/Projects" "$HOME/Downloads" "$HOME/Documents" "$HOME/Pictures/wallpapers" "$HOME/Pictures/Screenshots"

echo ">>> Copying default applications config"
copy_config "$CONFIGS_DIR/mimeapps.list" "$HOME/.config/mimeapps.list"

# Print post-install reminders
echo ""
echo "============================================"
echo "  wayforged installation complete!"
echo "============================================"
echo ""
echo "POST-INSTALL REMINDERS:"
echo "  1. Copy your wallpapers to ~/Pictures/wallpapers/"
echo "  2. Import your GPG key and update ~/.gitconfig signingkey"
echo "  3. Add SSH key to GitHub: cat ~/.ssh/id_ed25519.pub"
echo "  4. Log out and log back in for zsh to take effect"
echo "  5. Configure Neovim to your liking"
if [ "${WAYFORGED_MODE:-minimal}" = "full" ]; then
  echo "  6. Set up Rust toolchain: rustup default stable"
  echo "  7. Optional: Run docker-setup.sh for Docker"
  echo "  8. Optional: Run virt-manager-setup.sh for VMs"
fi
echo ""

echo ">>> Finalization complete"
