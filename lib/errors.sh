#!/usr/bin/env bash
# Error handling with recovery menu

CURRENT_PHASE_NUM=""
CURRENT_PHASE_NAME=""
CURRENT_PHASE_SCRIPT=""

handle_error() {
  local exit_code="${1:-1}"
  stop_log_output
  show_cursor

  clear_logo
  echo
  gum style --foreground 1 --padding "1 0 1 $PADDING_LEFT" "Installation stopped!"
  echo

  if [ -n "${CURRENT_SCRIPT:-}" ]; then
    gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" "Failed: $CURRENT_SCRIPT (exit code $exit_code)"
  fi
  echo

  # Show last 8 log lines
  if [ -f "$LOG_FILE" ]; then
    tail -8 "$LOG_FILE" 2>/dev/null | while IFS= read -r line; do
      local max_w=$((TERM_WIDTH - PADDING_LEFT - 6))
      [ "${#line}" -gt "$max_w" ] && line="${line:0:$max_w}..."
      gum style --foreground 8 --padding "0 0 0 $PADDING_LEFT" "  → $line"
    done
  fi
  echo

  while true; do
    local choice
    choice=$(gum choose \
      --header "What would you like to do?" \
      --padding "$PADDING" \
      "Retry this phase" \
      "Skip this phase" \
      "View full log" \
      "Exit")

    case "$choice" in
      "Retry this phase")
        if [ -n "${CURRENT_PHASE_SCRIPT:-}" ]; then
          return 42  # special code: retry
        fi
        ;;
      "Skip this phase")
        return 0
        ;;
      "View full log")
        less "$LOG_FILE" 2>/dev/null || tail -50 "$LOG_FILE"
        ;;
      "Exit"|"")
        echo
        gum style --foreground 1 --padding "0 0 0 $PADDING_LEFT" "Installation aborted. Log saved to: $LOG_FILE"
        exit 1
        ;;
    esac
  done
}
