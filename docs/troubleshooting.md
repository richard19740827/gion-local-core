# Troubleshooting

Concrete diagnostic flows for the most common failure modes when running Hermes WebUI. Each entry has the symptom, the diagnostic commands you should run *before* opening an issue, and the fix that has worked for past reporters.

If your symptom isn't listed and the diagnostics don't narrow it down, file a bug at https://github.com/nesquena/hermes-webui/issues — include the **full output** of every command in the relevant section.

---

## "AIAgent not available -- check that hermes-agent is on sys.path"

**Symptom.** WebUI starts, shows the chat interface, but every chat request fails immediately with this error in the response or the server log. As of v0.51.6 the error includes a diagnostic block with the running Python interpreter, the relevant `sys.path` entries, and the most-common fix; on older versions the message is bare.

**Why it happens.** The WebUI imports the agent class at chat time via `from run_agent import AIAgent`. That import only succeeds if the running Python's `sys.path` contains either the hermes-agent checkout or a pip-installed copy of the agent. Three common failure modes:

1. **Agent installed but not on `sys.path`.** Most common. The agent is checked out somewhere (e.g. `~/Programmes/hermes-agent`), the WebUI was launched with a Python that doesn't know about it, and there's no `pip install -e .` linking the two.
2. **Symlink with a typo or wrong target.** A symlink to the agent looks correct on `ls`, but `readlink` resolves to a path that doesn't exist or doesn't contain `agent/__init__.py`.
3. **`HERMES_WEBUI_AGENT_DIR` set to the wrong directory.** Override env var beats auto-discovery and points at a directory that has no agent code.

### Step 1 — confirm the agent location

```bash
# If you have ~/hermes-agent (the default location):
ls -la ~/hermes-agent
readlink ~/hermes-agent          # if it's a symlink, where does it resolve?
ls ~/hermes-agent/agent/__init__.py 2>&1
```

The third command must succeed (the file must exist). If it fails, your symlink is broken or pointing at a directory that's missing the agent module — fix that first.

### Step 2 — confirm the WebUI is using the right Python

```bash
cd ~/hermes-webui && ./start.sh 2>&1 | grep -iE 'agent|python|hermes_webui_python' | head -20
```

The startup banner prints which Python and agent dir it resolved. If the agent dir is empty or the Python is the wrong one, set the override:

```bash
export HERMES_WEBUI_AGENT_DIR=/absolute/path/to/hermes-agent
export HERMES_WEBUI_PYTHON=/absolute/path/to/agent/venv/bin/python
./start.sh
```

### Step 3 — install the agent in editable mode

This is the most common fix and resolves the original issue #1695:

```bash
cd /path/to/hermes-agent          # the directory holding pyproject.toml + the agent/ module
pip install -e .                  # use the same python that runs the WebUI
```

Then restart the WebUI:

```bash
cd ~/hermes-webui
./start.sh
```

### Step 4 — verify by importing manually

If steps 1-3 still don't work, check whether the WebUI's Python can import the agent at all:

```bash
$HERMES_WEBUI_PYTHON -c "from run_agent import AIAgent; print('ok')" 2>&1
```

(Replace `$HERMES_WEBUI_PYTHON` with the actual Python path from step 2 if the env var isn't set.) If this prints `ok`, the agent IS on `sys.path` for that Python — and the WebUI should work.

If this fails, `import run_agent` itself is broken — check that the agent's pyproject.toml lists `run_agent` as a top-level module or that the agent dir is on PYTHONPATH:

```bash
PYTHONPATH=/path/to/hermes-agent $HERMES_WEBUI_PYTHON -c "from run_agent import AIAgent; print('ok')"
```

If adding PYTHONPATH fixes it, persist the path either via `pip install -e .` (preferred) or by setting `HERMES_WEBUI_AGENT_DIR` to that directory.

### When to file a bug

If after running steps 1-4 the import still fails *and* `pip install -e .` succeeded *and* `PYTHONPATH=... python -c "from run_agent import AIAgent"` succeeds — that's a real WebUI bug. File at https://github.com/nesquena/hermes-webui/issues with:

- The output of every command in steps 1-4
- The full diagnostic block printed by the WebUI's `ImportError` (v0.51.6+)
- Your OS, Python version, and how the agent was installed

---

## 數位蓮花：訊息閘道打不開

**症狀。** WebUI 可以在瀏覽器打開，但是 Telegram / Discord / Slack 沒有回應；控制中心的 Gateway 卡片顯示尚未設定；或你不知道 Hermes 真正讀到的是哪一個 `config.yaml`。

**先記住一句話。** WebUI 只是看得到對話；真正讓 Telegram / Discord / Slack 活起來的是 Hermes Agent 的 messaging gateway。也就是說，要先確認 Agent 的家目錄、設定檔、密鑰、gateway 程序都指向同一個地方。

### 第 1 步 — 找到 Hermes 真正使用的設定檔

在 macOS 或 Linux 終端機執行：

```bash
printf 'HERMES_HOME=%s\n' "${HERMES_HOME:-$HOME/.hermes}"
printf 'HERMES_CONFIG_PATH=%s\n' "${HERMES_CONFIG_PATH:-${HERMES_HOME:-$HOME/.hermes}/config.yaml}"
ls -la "${HERMES_HOME:-$HOME/.hermes}"
```

重點只看兩個值：

- `HERMES_HOME`：Hermes 的家目錄，通常是 `~/.hermes`。
- `HERMES_CONFIG_PATH`：Hermes 真的會讀的設定檔，通常是 `~/.hermes/config.yaml`。

如果你用 Docker 跑 WebUI，也要進容器確認同一份設定檔存在：

```bash
docker exec hermes-webui ls -la /home/hermeswebui/.hermes/config.yaml
docker exec hermes-webui sed -n '1,220p' /home/hermeswebui/.hermes/config.yaml
```

### 第 2 步 — 不要把 Bot token 放進截圖或 git

Bot token 請放在 `.env` 或 shell 環境變數，不要直接寫進會提交的 YAML：

```bash
cat >> ~/.hermes/.env <<'EOF_ENV'
TELEGRAM_BOT_TOKEN=123456:replace-me
TELEGRAM_ALLOWED_CHAT_IDS=123456789
EOF_ENV
chmod 600 ~/.hermes/.env
```

分享畫面、log、截圖之前，請遮掉 `TELEGRAM_BOT_TOKEN`、`DISCORD_BOT_TOKEN`、`SLACK_BOT_TOKEN`、API key、資料庫網址與 webhook 網址。

### 第 3 步 — 在 Agent 設定檔裡打開通道

不同 Hermes Agent 版本的欄位名稱可能不同；如果你的版本有自己的 gateway / channel 文件，請以 Agent 文件為準。常見概念如下：在 YAML 裡啟用通道，但秘密值只用環境變數名稱引用。

```yaml
messaging:
  telegram:
    enabled: true
    token_env: TELEGRAM_BOT_TOKEN
    allowed_chat_ids_env: TELEGRAM_ALLOWED_CHAT_IDS
```

如果你的 Agent 使用 `gateway:` 或 `channels:`，原則仍相同：YAML 只負責「打開 Telegram」，真正的 token 留在 `.env` 或系統環境變數。

### 第 4 步 — 從同一個環境啟動或重啟 gateway

請在已經載入 `HERMES_HOME` 與 token 的同一個 shell 執行：

```bash
set -a
[ -f ~/.hermes/.env ] && . ~/.hermes/.env
set +a
hermes gateway start
```

如果你用 Docker Compose，請重啟擁有 Hermes Agent / gateway 的服務，然後看 log：

```bash
docker compose restart hermes-webui
docker logs -f hermes-webui
```

### 第 5 步 — 確認 WebUI 看得到 gateway

打開 Control Center → System，看 Gateway status 卡片。也可以直接查 API：

```bash
curl -s http://127.0.0.1:8787/api/gateway/status
```

判讀方式：

1. `configured: false`：WebUI 還找不到 Agent gateway metadata。
2. `configured: true, running: false`：設定資料存在，但 gateway 停了或狀態過期。
3. `configured: true, running: true`：gateway 程序活著。
4. `platforms`：通常要等 gateway 寫入 session 或身份 metadata 後，才會列出 Telegram / Discord / Slack。

### 很累時的最短恢復清單

如果你現在只想讓「數位蓮花」先開起來，照順序跑這四段：

```bash
# 1) 確認目前的 home/config。
printf 'home=%s\nconfig=%s\n' "${HERMES_HOME:-$HOME/.hermes}" "${HERMES_CONFIG_PATH:-${HERMES_HOME:-$HOME/.hermes}/config.yaml}"

# 2) 確認 token 已載入，但不要把 token 印出來。
test -n "$TELEGRAM_BOT_TOKEN" && echo 'telegram token loaded'

# 3) 確認 WebUI 可連線。
curl -fsS http://127.0.0.1:8787/api/system/health >/dev/null && echo 'webui ok'

# 4) 確認 gateway 狀態。
curl -s http://127.0.0.1:8787/api/gateway/status
```

如果第 2 步失敗，重新載入 `~/.hermes/.env`。如果第 3 步失敗，先啟動 WebUI。如果第 4 步顯示 gateway 未設定，請回頭檢查 `HERMES_HOME`、`HERMES_CONFIG_PATH`，以及 Agent / gateway 是否真的從同一個 home 目錄啟動。

---

## "Messaging gateway channel not opening"

**Symptom.** WebUI works in the browser, but Telegram/Discord/Slack feels like a hidden "channel switch": the bot does not answer, the Control Center gateway card says the gateway is not configured, or you are not sure which `config.yaml` Hermes is reading.

**Why it happens.** WebUI can display messaging sessions, but the messaging gateway is owned by Hermes Agent. It reads the Agent config under `HERMES_HOME`, writes gateway runtime metadata there, and only then can WebUI show `/api/gateway/status` as configured/running. A repo-level `config.yaml` is only a sample/local development file unless `HERMES_CONFIG_PATH` points at it.

### Step 1 — find the config Hermes is actually using

On macOS or Linux, start with the active environment instead of searching every random config file in Finder:

```bash
printf 'HERMES_HOME=%s\n' "${HERMES_HOME:-$HOME/.hermes}"
printf 'HERMES_CONFIG_PATH=%s\n' "${HERMES_CONFIG_PATH:-${HERMES_HOME:-$HOME/.hermes}/config.yaml}"
ls -la "${HERMES_HOME:-$HOME/.hermes}"
```

If WebUI runs in Docker, verify the file inside the container too:

```bash
docker exec hermes-webui ls -la /home/hermeswebui/.hermes/config.yaml
docker exec hermes-webui sed -n '1,220p' /home/hermeswebui/.hermes/config.yaml
```

### Step 2 — keep secrets out of screenshots and git

Put bot tokens in `.env` or your shell environment, not directly in committed YAML:

```bash
cat >> ~/.hermes/.env <<'EOF_ENV'
TELEGRAM_BOT_TOKEN=123456:replace-me
TELEGRAM_ALLOWED_CHAT_IDS=123456789
EOF_ENV
chmod 600 ~/.hermes/.env
```

Before sharing logs or screenshots, redact values named like `TELEGRAM_BOT_TOKEN`, `DISCORD_BOT_TOKEN`, `SLACK_BOT_TOKEN`, provider API keys, database URLs, and webhook URLs.

### Step 3 — turn on the channel in the Agent config

The exact schema is owned by Hermes Agent, so check your Agent version's channel or gateway docs first. A typical config keeps channel enablement in the Agent config and secrets in environment variables:

```yaml
messaging:
  telegram:
    enabled: true
    token_env: TELEGRAM_BOT_TOKEN
    allowed_chat_ids_env: TELEGRAM_ALLOWED_CHAT_IDS
```

If your Agent uses a `gateway:` or `channels:` key instead, keep the same principle: enable Telegram in YAML, reference secret names, and store the secret values outside git.

### Step 4 — start or restart the gateway

From the same shell that has `HERMES_HOME` and the token environment loaded:

```bash
set -a
[ -f ~/.hermes/.env ] && . ~/.hermes/.env
set +a
hermes gateway start
```

If your installation uses Docker Compose, restart the service that owns Hermes Agent/gateway, then watch logs:

```bash
docker compose restart hermes-webui
docker logs -f hermes-webui
```

### Step 5 — confirm WebUI can see the gateway

Open Control Center → System and check the Gateway status card. You can also query the API directly:

```bash
curl -s http://127.0.0.1:8787/api/gateway/status
```

Expected progression:

1. `configured: false` means WebUI cannot find Agent gateway metadata yet.
2. `configured: true, running: false` means metadata exists but the gateway is stopped or stale.
3. `configured: true, running: true` means the gateway process is alive.
4. `platforms` lists Telegram/Discord/Slack only after sessions or identity metadata have been written by the gateway.

### Fast recovery checklist

When you are tired and just need the channel open, run this checklist in order:

```bash
# 1) Confirm the active home/config.
printf 'home=%s\nconfig=%s\n' "${HERMES_HOME:-$HOME/.hermes}" "${HERMES_CONFIG_PATH:-${HERMES_HOME:-$HOME/.hermes}/config.yaml}"

# 2) Confirm the token is present without printing it.
test -n "$TELEGRAM_BOT_TOKEN" && echo 'telegram token loaded'

# 3) Confirm WebUI is reachable.
curl -fsS http://127.0.0.1:8787/api/system/health >/dev/null && echo 'webui ok'

# 4) Confirm gateway status.
curl -s http://127.0.0.1:8787/api/gateway/status
```

If step 2 fails, reload `~/.hermes/.env`. If step 3 fails, start WebUI. If step 4 says the gateway is not configured, focus on `HERMES_HOME`, `HERMES_CONFIG_PATH`, and whether the Agent/gateway process is running from that same home directory.

---

## Other troubleshooting

This document grows over time. If a recurring failure mode isn't covered here yet, add it via PR. The format for each entry: **Symptom → Why → Diagnostic commands → Fix → When to file a bug**.

Related references:

- [`docs/supervisor.md`](supervisor.md) — process-supervisor setup (launchd, systemd, supervisord, runit/s6) including the bootstrap supervisor-foreground flag.
- [`docs/docker.md`](docker.md) — Docker compose setup, common failure modes, bind-mount migration.
- [`docs/wsl-autostart.md`](wsl-autostart.md) — WSL2 auto-start at login on Windows.
- [`docs/EXTENSIONS.md`](EXTENSIONS.md) — WebUI extension injection, security model, examples.
