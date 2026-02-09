# wayforged

A TUI-based installer that recreates a complete Fedora Hyprland developer environment from scratch.

```
                     __                          __
 _      ______ ___  / /_____  _________ ____  __/ /
| | /| / / __ `/ / / / /_/ __ \/ ___/ __ `/ _ \/ __  /
| |/ |/ / /_/ / /_/ / __/ /_/ / /  / /_/ /  __/ /_/ /
|__/|__/\__,_/\__, /\__/\____/_/   \__, /\___/\__,_/
             /____/               /____/

       Fedora · Wayland · Hyprland
```

## What It Does

wayforged automates the setup of a fully-configured Fedora Hyprland desktop — from window manager and shell to editors, dev tools, and a system-wide Tokyo Night theme. It uses [gum](https://github.com/charmbracelet/gum) for a clean terminal UI, runs through 14 installation phases, and lets you choose exactly what gets installed.

Every phase is idempotent. You can re-run the installer safely without breaking anything.

## Features

- **Tokyo Night everywhere** — GTK theme, terminal, Waybar, Rofi, editors
- **TUI-driven** — interactive menus powered by gum (auto-installed if missing)
- **3 install modes** — Minimal, Full, or Custom (pick individual components)
- **14 phases** — modular scripts that can be run independently
- **Idempotent** — safe to re-run; skips what's already installed
- **Error recovery** — retry, skip, view logs, or exit on any failure
- **22 dotfiles** — pre-configured configs for Hyprland, Waybar, Rofi, Ghostty, Zsh, and more

## Requirements

- Fedora 42+ (or compatible Fedora-based distro)
- Wayland session
- Internet connection
- `sudo` access

## Quick Start

```bash
git clone https://github.com/your-username/wayforged.git
cd wayforged
./install.sh
```

The installer will bootstrap `gum` if it's not already installed, then walk you through mode selection and confirmation before touching anything.

## Install Modes

### Minimal

The core desktop and dev environment:

- Hyprland + Wayland stack (Waybar, Rofi, SwayNC, Hyprpaper, Hyprlock)
- Ghostty terminal
- Zsh + Oh My Zsh + plugins (autosuggestions, completions, syntax highlighting)
- Neovim + Zed editors
- Node.js ecosystem (NVM, Node 24, pnpm, Bun)
- Zen Browser
- CLI tools (eza, bat, fzf, yazi, fastfetch, zoxide)
- Tokyo Night GTK theme + Nerd Fonts
- Git configuration + SSH key generation

### Full

Everything in Minimal, plus:

- Rust (via rustup)
- Go + Go tools (gopls, delve, goimports)
- C/C++ toolchain (gcc, clang, cmake)
- Python pip + Protocol Buffers
- VLC, OBS Studio, tmux
- Slack, Obsidian, GearLever
- typescript-language-server
- Additional systemd services (fstrim timer)

### Custom

Pick individual phases from the full list. All phases are pre-selected by default — deselect what you don't need.

## What Gets Installed

| Phase | Name | Minimal | Full | Description |
|-------|------|:-------:|:----:|-------------|
| 01 | Repositories | ✓ | ✓ | RPM Fusion, COPRs (Hyprland, Ghostty), Flathub |
| 02 | Hyprland & Wayland | ✓ | ✓ | Hyprland, Waybar, Rofi, SwayNC, portals, utilities |
| 03 | Tokyo Night Theme | ✓ | ✓ | GTK theme, gsettings, dark mode, Xresources |
| 04 | Nerd Fonts | ✓ | ✓ | JetBrains Mono NF, Iosevka NF |
| 05 | Ghostty Terminal | ✓ | ✓ | Ghostty terminal emulator + config |
| 06 | Zsh & Oh My Zsh | ✓ | ✓ | Zsh, Oh My Zsh, plugins, .zshrc |
| 07 | CLI Tools | ✓ | ✓ | eza, bat, fzf, yazi, fastfetch, zoxide, and more |
| 08 | Node.js Ecosystem | ✓ | ✓ | NVM, Node.js 24, corepack, pnpm, Bun |
| 09 | Editors | ✓ | ✓ | Neovim + Zed with configs |
| 10 | Git Configuration | ✓ | ✓ | Git config + SSH key generation |
| 11 | Applications | ✓ | ✓ | Zen Browser (both); VLC, OBS, Slack, Obsidian (full) |
| 12 | Languages | — | ✓ | Rust, Go, C/C++, Python pip, protobuf |
| 13 | System Services | ✓ | ✓ | GDM, NetworkManager, firewalld, sshd, Bluetooth |
| 14 | Finalize | ✓ | ✓ | Directory creation, default apps, post-install reminders |

## Project Structure

```
wayforged/
├── install.sh              # Main TUI entry point
├── logo.txt                # ASCII art logo
├── README.md
├── lib/
│   ├── presentation.sh     # gum theming, logo display
│   ├── logging.sh          # Log tailing, run_logged
│   ├── errors.sh           # Error recovery menu
│   └── utils.sh            # Helper functions
├── phases/
│   ├── 01-repos.sh         # RPM Fusion, COPRs, Flathub
│   ├── 02-hyprland.sh      # Hyprland + Wayland stack
│   ├── 03-theme.sh         # Tokyo Night GTK theme
│   ├── 04-fonts.sh         # JetBrains Mono NF, Iosevka NF
│   ├── 05-terminal.sh      # Ghostty terminal
│   ├── 06-shell.sh         # Zsh + Oh My Zsh + plugins
│   ├── 07-cli.sh           # eza, bat, fzf, yazi, etc.
│   ├── 08-node.sh          # NVM, Node.js, pnpm, Bun
│   ├── 09-editors.sh       # Neovim + Zed
│   ├── 10-git.sh           # Git config + SSH key
│   ├── 11-apps.sh          # Zen Browser, VLC, OBS, etc.
│   ├── 12-languages.sh     # Rust, Go, C/C++ (full only)
│   ├── 13-services.sh      # systemd services
│   └── 14-finalize.sh      # Final setup + reminders
├── configs/                # Dotfiles (22 config files)
│   ├── hypr/               # Hyprland configs
│   ├── waybar/             # Waybar config + style
│   ├── rofi/               # Rofi config + Tokyo Night theme
│   ├── ghostty/            # Ghostty config
│   ├── gtk-3.0/            # GTK3 settings
│   ├── gtk-4.0/            # GTK4 settings
│   ├── zed/                # Zed editor settings
│   ├── zshrc               # Zsh config
│   ├── gitconfig           # Git config
│   └── ...                 # Other dotfiles
└── scripts/
    ├── wifimenu            # Rofi WiFi selector
    └── powermenu           # Rofi power menu
```

## Customization

### Before Running

Edit any config file in `configs/` before running the installer. The phase scripts copy these files to their final locations (`~/.config/`, `~/`, etc.), so your changes will be picked up automatically.

### Adding a Phase

1. Create a new script in `phases/` following the naming convention (`15-myfeature.sh`)
2. Add the phase entry to the `PHASES` array in `install.sh`:
   ```bash
   "15|My Feature|$PHASES_DIR/15-myfeature.sh|both"
   ```
3. Use `both` for all modes or `full` for full-only

### Removing a Phase

Remove or comment out the corresponding line in the `PHASES` array in `install.sh`. Or just use Custom mode and deselect it at runtime.

## Post-Install

After installation completes, remember to:

1. **Copy wallpapers** to `~/Pictures/wallpapers/`
2. **Import your GPG key** and update `~/.gitconfig` with your signing key
3. **Add your SSH key** to GitHub — `cat ~/.ssh/id_ed25519.pub`
4. **Log out and back in** for Zsh and Hyprland to take effect
5. **Configure Neovim** to your liking

If you ran the Full install:

6. Set up Rust toolchain: `rustup default stable`

## Optional (Coming Soon)

- **Docker** — `docker-setup.sh` for Docker Engine + Docker Compose
- **virt-manager** — `virt-manager-setup.sh` for KVM/QEMU virtual machines

## License

MIT
