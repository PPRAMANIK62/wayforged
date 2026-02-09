#!/usr/bin/env bash
set -eEo pipefail

# Resolve project root
WAYFORGED_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export WAYFORGED_ROOT

# ─── BOOTSTRAP GUM ───
bootstrap_gum() {
  if command -v gum &>/dev/null; then return 0; fi
  echo "Installing gum (TUI toolkit)..."
  # Try Charm repo first
  sudo mkdir -p /etc/yum.repos.d
  sudo tee /etc/yum.repos.d/charm.repo > /dev/null <<'EOF'
[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key
EOF
  sudo dnf install -y gum
}

bootstrap_gum

# Source all lib files
source "$WAYFORGED_ROOT/lib/presentation.sh"
source "$WAYFORGED_ROOT/lib/logging.sh"
source "$WAYFORGED_ROOT/lib/errors.sh"
source "$WAYFORGED_ROOT/lib/utils.sh"

# Trap errors
trap 'handle_error $?' ERR

# ─── PHASE DEFINITIONS ───
# Each phase: "number|name|script|modes"
# modes: "both" = minimal+full, "full" = full only
PHASES=(
  "01|Repositories|$PHASES_DIR/01-repos.sh|both"
  "02|Hyprland & Wayland|$PHASES_DIR/02-hyprland.sh|both"
  "03|Tokyo Night Theme|$PHASES_DIR/03-theme.sh|both"
  "04|Nerd Fonts|$PHASES_DIR/04-fonts.sh|both"
  "05|Ghostty Terminal|$PHASES_DIR/05-terminal.sh|both"
  "06|Zsh & Oh My Zsh|$PHASES_DIR/06-shell.sh|both"
  "07|CLI Tools|$PHASES_DIR/07-cli.sh|both"
  "08|Node.js Ecosystem|$PHASES_DIR/08-node.sh|both"
  "09|Editors (Neovim + Zed)|$PHASES_DIR/09-editors.sh|both"
  "10|Git Configuration|$PHASES_DIR/10-git.sh|both"
  "11|Applications|$PHASES_DIR/11-apps.sh|both"
  "12|Languages (Rust, Go, C++)|$PHASES_DIR/12-languages.sh|full"
  "13|System Services|$PHASES_DIR/13-services.sh|both"
  "14|Finalize|$PHASES_DIR/14-finalize.sh|both"
)

# ─── WELCOME SCREEN ───
show_welcome() {
  clear
  clear_logo
  echo
  gum style --foreground 5 --padding "0 0 0 $PADDING_LEFT" \
    "Welcome to wayforged — your Fedora Hyprland environment installer"
  echo
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "This will set up your complete development environment."
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "Make sure you have a working internet connection."
  echo

  if ! gum confirm "Ready to begin?"; then
    echo
    gum style --foreground 1 --padding "0 0 0 $PADDING_LEFT" "Installation cancelled."
    exit 0
  fi
}

# ─── MODE SELECTION ───
select_mode() {
  clear_logo
  echo
  gum style --foreground 5 --padding "0 0 0 $PADDING_LEFT" "Choose installation mode:"
  echo

  # Show mode descriptions
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "Minimal  — Hyprland, terminal, shell, editors, Node.js, Zen Browser"
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "Full     — Everything in Minimal + Rust, Go, C++, VLC, OBS, Slack, Obsidian"
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "Custom   — Pick individual components"
  echo

  WAYFORGED_MODE=$(gum choose "minimal" "full" "custom")
  export WAYFORGED_MODE
}

# ─── CUSTOM SELECTION ───
# For custom mode, let user pick which phases to run using gum choose --no-limit
select_custom_phases() {
  clear_logo
  echo
  gum style --foreground 5 --padding "0 0 0 $PADDING_LEFT" "Select components to install:"
  echo

  # Build list of phase names for selection
  local phase_names=()
  for phase in "${PHASES[@]}"; do
    IFS='|' read -r num name script modes <<< "$phase"
    phase_names+=("$num $name")
  done

  # Let user select (all selected by default)
  SELECTED_PHASES=$(printf '%s\n' "${phase_names[@]}" | \
    gum choose --no-limit --selected "${phase_names[*]}")

  export SELECTED_PHASES
}

# ─── PHASE RUNNER LOGIC ───
should_run_phase() {
  local num="$1" modes="$2"

  case "$WAYFORGED_MODE" in
    minimal)
      [ "$modes" = "both" ]
      ;;
    full)
      return 0  # run all phases
      ;;
    custom)
      echo "$SELECTED_PHASES" | grep -q "^$num "
      ;;
  esac
}

# ─── CONFIRMATION ───
show_confirmation() {
  clear_logo
  echo

  local mode_display="$WAYFORGED_MODE"
  gum style --foreground 5 --padding "0 0 0 $PADDING_LEFT" "Installation Summary"
  echo
  gum style --foreground 6 --padding "0 0 0 $PADDING_LEFT" "Mode: $mode_display"
  echo

  # Show phases that will run
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" "Phases to install:"
  for phase in "${PHASES[@]}"; do
    IFS='|' read -r num name script modes <<< "$phase"
    if should_run_phase "$num" "$modes"; then
      gum style --foreground 2 --padding "0 0 0 $PADDING_LEFT" "  ✓ $num. $name"
    else
      gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" "  ✗ $num. $name (skipped)"
    fi
  done
  echo

  if ! gum confirm "Proceed with installation?"; then
    echo
    gum style --foreground 1 --padding "0 0 0 $PADDING_LEFT" "Installation cancelled."
    exit 0
  fi
}

# ─── MAIN EXECUTION ───
main() {
  show_welcome
  select_mode

  if [ "$WAYFORGED_MODE" = "custom" ]; then
    select_custom_phases
  fi

  show_confirmation

  # Start installation
  clear_logo
  show_status "Starting installation..."
  echo
  start_install_log

  local completed=0
  local total=0

  # Count phases to run
  for phase in "${PHASES[@]}"; do
    IFS='|' read -r num name script modes <<< "$phase"
    if should_run_phase "$num" "$modes"; then
      total=$((total + 1))
    fi
  done

  # Execute phases
  for phase in "${PHASES[@]}"; do
    IFS='|' read -r num name script modes <<< "$phase"
    if should_run_phase "$num" "$modes"; then
      run_phase "$num" "$name" "$script"
      completed=$((completed + 1))
    fi
  done

  stop_install_log

  # ─── COMPLETION SCREEN ───
  clear_logo
  echo
  gum style --foreground 2 --padding "1 0 0 $PADDING_LEFT" \
    "✓ Installation complete!"
  echo
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "Mode: $WAYFORGED_MODE | Phases: $completed/$total | Duration: ${WAYFORGED_DURATION:-unknown}"
  gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" \
    "Log: $LOG_FILE"
  echo
  gum style --foreground 3 --padding "0 0 0 $PADDING_LEFT" \
    "Please log out and log back in for all changes to take effect."
  echo
  show_cursor
}

main "$@"
