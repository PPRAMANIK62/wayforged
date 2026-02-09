#!/usr/bin/env bash
# Phase 01: Repository Setup
# Adds RPM Fusion, COPR repos, Flathub, and optionally Slack repo

echo ">>> Adding RPM Fusion free + nonfree repositories"
sudo dnf install -y \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
  || true  # may already be installed

echo ">>> Adding COPR repositories"
sudo dnf copr enable -y solopasha/hyprland
sudo dnf copr enable -y pgdev/ghostty

echo ">>> Adding Flathub remote"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

if [ "${WAYFORGED_MODE:-minimal}" = "full" ]; then
  echo ">>> Importing Slack GPG key and adding Slack repo"
  sudo rpm --import https://slack.com/gpg/slack_pubkey_20230710.gpg

  sudo tee /etc/yum.repos.d/slack.repo > /dev/null <<'SLACKREPO'
[slack]
name=slack
baseurl=https://packagemanager.clients.google.com/yumrepos/slack-x86_64
enabled=1
gpgcheck=1
gpgkey=https://slack.com/gpg/slack_pubkey_20230710.gpg
SLACKREPO
fi

echo ">>> Repository setup complete"
