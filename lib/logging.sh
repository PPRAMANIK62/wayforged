#!/usr/bin/env bash
# Live log tailing and run_logged helper

LOG_FILE="${LOG_FILE:-/tmp/wayforged-install.log}"
LOG_PID=""

start_log_output() {
  printf "\033[s"
  hide_cursor

  (
    local log_lines=8
    local max_line_width=$((LOGO_WIDTH > 0 ? LOGO_WIDTH : 60))

    while true; do
      mapfile -t current_lines < <(tail -n "$log_lines" "$LOG_FILE" 2>/dev/null)

      output=""
      for ((i = 0; i < log_lines; i++)); do
        line="${current_lines[i]:-}"
        if [ "${#line}" -gt "$max_line_width" ]; then
          line="${line:0:$max_line_width}..."
        fi
        if [ -n "$line" ]; then
          output+="\033[2K\033[90m${PADDING_LEFT_SPACES}  → ${line}\033[0m\n"
        else
          output+="\033[2K${PADDING_LEFT_SPACES}\n"
        fi
      done

      printf "\033[u%b" "$output"
      sleep 0.15
    done
  ) &
  LOG_PID=$!
}

stop_log_output() {
  if [ -n "${LOG_PID:-}" ]; then
    kill "$LOG_PID" 2>/dev/null || true
    wait "$LOG_PID" 2>/dev/null || true
    unset LOG_PID
  fi
}

start_install_log() {
  : > "$LOG_FILE"
  echo "=== wayforged installation started: $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"
  export WAYFORGED_START_EPOCH=$(date +%s)
  start_log_output
}

stop_install_log() {
  stop_log_output
  show_cursor
  local end_epoch
  end_epoch=$(date +%s)
  local duration=$(( end_epoch - ${WAYFORGED_START_EPOCH:-$end_epoch} ))
  local mins=$(( duration / 60 ))
  local secs=$(( duration % 60 ))
  echo "=== wayforged installation completed: $(date '+%Y-%m-%d %H:%M:%S') (${mins}m ${secs}s) ===" >> "$LOG_FILE"
  export WAYFORGED_DURATION="${mins}m ${secs}s"
}

run_logged() {
  local script="$1"
  export CURRENT_SCRIPT="$script"
  echo "[$(date '+%H:%M:%S')] Starting: $script" >> "$LOG_FILE"
  bash -c "source '$script'" </dev/null >> "$LOG_FILE" 2>&1
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    echo "[$(date '+%H:%M:%S')] Done: $script" >> "$LOG_FILE"
  else
    echo "[$(date '+%H:%M:%S')] FAILED ($exit_code): $script" >> "$LOG_FILE"
  fi
  unset CURRENT_SCRIPT
  return $exit_code
}
