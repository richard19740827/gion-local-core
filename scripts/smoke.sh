#!/bin/sh
set -eu

COMPOSE_FILE="docker-compose.yml"
SERVICE="hermes-webui"
HEALTH_URL="http://127.0.0.1:8787/health"
PROJECT_NAME="gion-local-core-smoke-$$"

if ! command -v docker >/dev/null 2>&1 || ! docker compose version >/dev/null 2>&1; then
  echo "FAIL: docker compose is required" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "FAIL: curl is required" >&2
  exit 1
fi

tmpdir=$(mktemp -d)
cleanup() {
  COMPOSE_PROJECT_NAME="$PROJECT_NAME" docker compose -f "$COMPOSE_FILE" down --volumes --remove-orphans >/dev/null 2>&1 || true
  rm -rf "$tmpdir"
}
trap cleanup EXIT INT TERM

export COMPOSE_PROJECT_NAME="$PROJECT_NAME"
export HERMES_HOME="$tmpdir/hermes-home"
export HERMES_WORKSPACE="$tmpdir/workspace"

mkdir -p "$HERMES_HOME" "$HERMES_WORKSPACE"

docker compose -f "$COMPOSE_FILE" config >/dev/null
docker compose -f "$COMPOSE_FILE" up -d

i=0
while [ "$i" -lt 60 ]; do
  if curl -fsS --max-time 3 "$HEALTH_URL" >/dev/null 2>&1; then
    echo "PASS: smoke health check passed"
    exit 0
  fi
  i=$((i + 1))
  sleep 2
done

echo "FAIL: smoke health check timed out" >&2
docker compose -f "$COMPOSE_FILE" logs --no-color --tail=200 "$SERVICE" >&2 || true
exit 1
