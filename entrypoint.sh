#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${OPENCLAW_STATE_DIR}/openclaw.json"

# Ensure config exists
if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$OPENCLAW_STATE_DIR"
  echo '{"gateway":{"mode":"local"}}' >"$CONFIG_FILE"
fi

# --- Start Tailscale ---
if [ -n "${TS_AUTHKEY:-}" ]; then
  echo "Starting tailscaled..."
  tailscaled --state=/var/lib/tailscale/tailscaled.state &

  # Wait for daemon to be ready
  until tailscale status >/dev/null 2>&1; do
    sleep 1
  done

  echo "Bringing Tailscale up..."
  tailscale up \
    --authkey="${TS_AUTHKEY}" \
    --hostname="${TS_HOSTNAME:-openclaw}" \
    --accept-routes \
    --reset
fi

echo "Starting OpenClaw..."
exec node dist/index.js gateway --bind loopback --port 18789
