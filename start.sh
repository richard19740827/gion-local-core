#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${HERMES_WEBUI_PYTHON:-}" ]]; then
  PYTHON="${HERMES_WEBUI_PYTHON}"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON="$(command -v python3)"
else
  echo "[start] Python 3 is required" >&2
  exit 1
fi
echo "[start] Delegating startup to bootstrap.py --foreground"
exec "${PYTHON}" "${REPO_ROOT}/bootstrap.py" --foreground "$@"
