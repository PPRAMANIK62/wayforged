#!/usr/bin/env bash
# Utility helpers

WAYFORGED_ROOT="${WAYFORGED_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIGS_DIR="$WAYFORGED_ROOT/configs"
SCRIPTS_DIR="$WAYFORGED_ROOT/scripts"
PHASES_DIR="$WAYFORGED_ROOT/phases"

command_exists() { command -v "$1" &>/dev/null; }

ensure_dir() {
  for dir in "$@"; do
    [ -d "$dir" ] || mkdir -p "$dir"
  done
}

copy_config() {
  local src="$1" dest="$2"
  ensure_dir "$(dirname "$dest")"
  cp -f "$src" "$dest"
  echo "  Wrote: $dest" >> "$LOG_FILE"
}

copy_config_dir() {
  local src_dir="$1" dest_dir="$2"
  ensure_dir "$dest_dir"
  cp -rf "$src_dir"/. "$dest_dir"/
  echo "  Copied: $src_dir → $dest_dir" >> "$LOG_FILE"
}

install_if_missing() {
  local cmd="$1" pkg="${2:-$1}"
  if ! command_exists "$cmd"; then
    sudo dnf install -y "$pkg" >> "$LOG_FILE" 2>&1
  fi
}

dnf_install() {
  sudo dnf install -y "$@" >> "$LOG_FILE" 2>&1
}

run_phase() {
  local phase_num="$1" phase_name="$2" phase_script="$3"

  CURRENT_PHASE_NUM="$phase_num"
  CURRENT_PHASE_NAME="$phase_name"
  CURRENT_PHASE_SCRIPT="$phase_script"

  stop_log_output
  clear_logo
  show_status "Installing... (Phase $phase_num: $phase_name)"
  echo
  start_log_output

  local result=0
  run_logged "$phase_script" || result=$?

  if [ "$result" -ne 0 ]; then
    handle_error "$result"
    local recovery=$?
    if [ "$recovery" -eq 42 ]; then
      # Retry
      run_phase "$phase_num" "$phase_name" "$phase_script"
      return $?
    fi
    return 0  # skipped
  fi

  return 0
}
