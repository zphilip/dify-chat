#!/bin/bash

# Keep container alive by tailing the platform combined log if present,
# otherwise fall back to an infinite sleep (tail /dev/null).

LOG_FILE="/app/logs/platform-combined.log"

if [ -f "$LOG_FILE" ]; then
  echo "Tailing $LOG_FILE to keep container alive"
  # Ensure nginx is running so static files are served
  if command -v nginx >/dev/null 2>&1; then
    echo "Starting nginx (if not already started)"
    nginx || true
  else
    echo "nginx not installed or not in PATH"
  fi

  tail -n +1 -f "$LOG_FILE"
else
  echo "Log file not found, keeping container alive (tail /dev/null)"
  # Start nginx in background if available so the container serves static files
  if command -v nginx >/dev/null 2>&1; then
    echo "Starting nginx (background)"
    nginx || true
  else
    echo "nginx not installed or not in PATH"
  fi

  tail -f /dev/null
fi
