#!/bin/sh
set -u

ENOWXAI_BIN="/root/.local/bin/enowxai"
HEALTH_URL="http://127.0.0.1:1430/health"

echo "[entrypoint] Starting EnowX AI supervisor..."

health_ok() {
  curl -sf "$HEALTH_URL" >/dev/null 2>&1
}

start_enowxai() {
  echo "[entrypoint] Running: enowxai start"
  "$ENOWXAI_BIN" start || true
}

start_enowxai

i=0
while [ "$i" -lt 30 ]; do
  if health_ok; then
    echo "[entrypoint] EnowX AI is healthy."
    break
  fi

  i=$((i + 1))
  echo "[entrypoint] Waiting for EnowX AI health... $i/30"
  sleep 2
done

if ! health_ok; then
  echo "[entrypoint] Health still failed. Trying stop/start once..."
  "$ENOWXAI_BIN" stop || true
  sleep 2
  start_enowxai
fi

while true; do
  if ! health_ok; then
    echo "[entrypoint] EnowX AI health failed. Restarting..."
    "$ENOWXAI_BIN" stop || true
    sleep 2
    start_enowxai
  fi

  sleep 30
done
