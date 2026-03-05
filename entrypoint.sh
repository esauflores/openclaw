#!/usr/bin/env bash
set -euo pipefail

OPENCLAW_DIR="${OPENCLAW_DIR:-/openclaw}"
OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-${OPENCLAW_DIR}/.openclaw}"

mkdir -p "${OPENCLAW_STATE_DIR}"
CONFIG_FILE="${OPENCLAW_STATE_DIR}/openclaw.json"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Creating default OpenClaw config..."
  cat <<EOF > "${CONFIG_FILE}"
{"gateway":{"mode":"local","bind":"loopback","tailscale":{"mode":"serve"}}}
EOF
fi

echo "Starting tailscaled..."

mkdir -p /var/run/tailscale
mkdir -p /var/lib/tailscale

tailscaled \
  --state=/var/lib/tailscale/tailscaled.state \
  --socket=/var/run/tailscale/tailscaled.sock &

for i in {1..30}; do
  [ -S /var/run/tailscale/tailscaled.sock ] && break
  sleep 1
done

sleep 5

chown node:node /var/run/tailscale/tailscaled.sock || true


if [ -n "${TS_AUTHKEY:-}" ]; then
  echo "Authenticating with Tailscale..."

  tailscale --socket=/var/run/tailscale/tailscaled.sock up \
    --authkey="${TS_AUTHKEY}" \
    --hostname="${TS_HOSTNAME:-openclaw}" \
    --accept-routes \
    --reset
else
  echo "No TS_AUTHKEY provided; using existing Tailscale state"
fi

# Set the Tailscale user to "node" for proper permissions
tailscale --socket=/var/run/tailscale/tailscaled.sock set --operator=node

chown -R node:node "${OPENCLAW_DIR}" || true

echo "Starting OpenClaw..."
exec gosu node node dist/index.js gateway --port 18789
