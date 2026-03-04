#!/bin/bash
set -euo pipefail

CONFIG_FILE="${OPENCLAW_STATE_DIR}/openclaw.json"

if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$OPENCLAW_STATE_DIR"
  echo '{"gateway":{"mode":"local"}}' > "$CONFIG_FILE"
fi

exec node dist/index.js gateway --bind loopback --port 18789
