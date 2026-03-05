#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${OPENCLAW_STATE_DIR}/openclaw.json"

# Ensure config exists
if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$OPENCLAW_STATE_DIR"
  echo '{"gateway":{"mode":"local","bind":"loopback","tailscale":{"mode":"serve"}}}' >"$CONFIG_FILE"
fi

# --- Start Tailscale ---
echo "Starting tailscaled..."
tailscaled --state=/var/lib/tailscale/tailscaled.state &

# Wait for daemon socket to be ready
until [ -S /var/run/tailscale/tailscaled.sock ]; do
  sleep 1
done

# Authenticate if authkey provided; otherwise reconnect to existing state
if [ -n "${TS_AUTHKEY:-}" ]; then
  echo "Authenticating with Tailscale..."
  sleep 5 # Give tailscaled a moment to be fully ready
  tailscale up \
    --authkey="${TS_AUTHKEY}" \
    --hostname="${TS_HOSTNAME:-openclaw}" \
    --accept-routes \
    --reset; do
else
  echo "No TS_AUTHKEY; Tailscale running with existing state (if available)"
fi

echo "Starting OpenClaw..."
exec node dist/index.js gateway --port 18789
