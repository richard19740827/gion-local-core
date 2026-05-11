#!/usr/bin/env python3
"""Local bootstrap helper for Gion Local Core.

The Docker Compose flow is canonical. This helper prepares the same local
Hermes/Gion paths for host-side workflows and can optionally exec a known Python
web server module when this repository is combined with an application source
tree.
"""

from __future__ import annotations

import argparse
import os
import shlex
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent
DEFAULT_HOME = Path.home() / "Hermes_Gion_Core"
DEFAULT_WORKSPACE = DEFAULT_HOME / "Public_Welfare_Project"
DEFAULT_STATE_DIR = DEFAULT_HOME / "webui_history"
DEFAULT_WEBUI_SOURCE_DIR = REPO_ROOT


def load_env_file(path: Path) -> None:
    """Load a simple KEY=VALUE .env file without overriding existing env."""
    if not path.exists():
        return

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = os.path.expanduser(value)


def env_path(name: str, default: Path) -> Path:
    return Path(os.path.expanduser(os.environ.get(name, str(default)))).resolve()


def prepare_environment() -> dict[str, Path]:
    load_env_file(REPO_ROOT / ".env")

    hermes_home = env_path("HERMES_HOME", DEFAULT_HOME)
    workspace = env_path("HERMES_WORKSPACE", DEFAULT_WORKSPACE)
    state_dir = env_path("HERMES_WEBUI_STATE_DIR", DEFAULT_STATE_DIR)
    webui_source_dir = env_path("HERMES_WEBUI_SOURCE_DIR", DEFAULT_WEBUI_SOURCE_DIR)

    hermes_home.mkdir(parents=True, exist_ok=True)
    workspace.mkdir(parents=True, exist_ok=True)
    state_dir.mkdir(parents=True, exist_ok=True)

    os.environ.setdefault("HERMES_HOME", str(hermes_home))
    os.environ.setdefault("HERMES_WORKSPACE", str(workspace))
    os.environ.setdefault("HERMES_WEBUI_DEFAULT_WORKSPACE", str(workspace))
    os.environ.setdefault("HERMES_WEBUI_STATE_DIR", str(state_dir))
    os.environ.setdefault("HERMES_WEBUI_HOST", "127.0.0.1")
    os.environ.setdefault("HERMES_WEBUI_PORT", "8787")
    os.environ.setdefault("HERMES_WEBUI_SOURCE_DIR", str(webui_source_dir))

    return {
        "HERMES_HOME": hermes_home,
        "HERMES_WORKSPACE": workspace,
        "HERMES_WEBUI_STATE_DIR": state_dir,
        "HERMES_WEBUI_SOURCE_DIR": webui_source_dir,
    }


def find_server_command(source_dir: Path) -> tuple[list[str], Path] | None:
    explicit = os.environ.get("HERMES_WEBUI_COMMAND")
    if explicit:
        return shlex.split(explicit), source_dir

    candidates = [
        [sys.executable, "-m", "uvicorn", "server:app"],
        [sys.executable, "server.py"],
    ]
    server_py = source_dir / "server.py"
    for command in candidates:
        target = command[-1]
        if target == "server.py" and server_py.exists():
            return command, source_dir
        if target == "server:app" and server_py.exists():
            return (
                command
                + [
                    "--host",
                    os.environ["HERMES_WEBUI_HOST"],
                    "--port",
                    os.environ["HERMES_WEBUI_PORT"],
                ],
                source_dir,
            )
    return None


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Prepare and optionally start Gion Local Core")
    parser.add_argument("--foreground", action="store_true", help="exec the local WebUI process when available")
    parser.add_argument("--print-env", action="store_true", help="print resolved local paths")
    args, extra = parser.parse_known_args(argv)

    paths = prepare_environment()

    if args.print_env or not args.foreground:
        for key, value in paths.items():
            print(f"{key}={value}")

    if not args.foreground:
        return 0

    command_info = find_server_command(paths["HERMES_WEBUI_SOURCE_DIR"])
    if command_info is None:
        print("[bootstrap] Local Python server entrypoint not found.", file=sys.stderr)
        print(
            "[bootstrap] This gion-local-core repo is the launcher/config repo; "
            "it does not vendor the WebUI server code.",
            file=sys.stderr,
        )
        print(
            "[bootstrap] Set HERMES_WEBUI_SOURCE_DIR to a local WebUI source tree "
            "containing server.py, or use the canonical Docker flow: docker compose up -d",
            file=sys.stderr,
        )
        return 2

    command, cwd = command_info
    command.extend(extra)
    print(f"[bootstrap] Executing in {cwd}: {' '.join(shlex.quote(part) for part in command)}")
    return subprocess.call(command, cwd=cwd)


if __name__ == "__main__":
    raise SystemExit(main())
