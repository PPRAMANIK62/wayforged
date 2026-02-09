#!/usr/bin/env bash
# Phase 13: System Services
# Enables core system services (BOTH modes), plus full-mode extras

echo ">>> Enabling system services..."

# Core services (BOTH modes)
sudo systemctl enable --now gdm 2>/dev/null || true
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now firewalld 2>/dev/null || true
sudo systemctl enable --now sshd
sudo systemctl enable --now bluetooth

# Full mode: additional services
if [ "${WAYFORGED_MODE:-minimal}" = "full" ]; then
  echo ">>> Enabling full mode services"
  sudo systemctl enable --now fstrim.timer
fi

echo ">>> System services setup complete"
