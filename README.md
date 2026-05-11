# Hermes Web UI

[Hermes Agent](https://hermes-agent.nousresearch.com/) 是一個複雜的自主代理，它存在於您的伺服器上，透過終端或訊息傳遞應用程式訪問，它記住它所學的內容，並且越跑越久，能力就越強.

Hermes WebUI是瀏覽器中一個輕量級的黑暗主題網路應用程式介面 [Hermes Agent](https://hermes-agent.nousresearch.com/).
與CLI體驗完全平等——您可以在終端上完成的一切，

你可以透過這個使用者介面完成。 沒有構建步驟，沒有框架，沒有捆綁器。 只是蟒蛇

和香草JS.

佈局：三面板。 會話和導航的左側邊欄，聊天中心，

適合工作區檔案瀏覽。 模型、配置檔案和工作區控制在
the **composer footer** — always 作曲時可見。 迴圈上下文環

一目瞭然地顯示令牌的使用情況。 所有設定和會話工具都在
**Hermes Control Center** (launcher at the sidebar bottom).

<img width="2448" height="1748" alt="Hermes Web UI — three-panel layout" src="https://github.com/user-attachments/assets/6bf8af4c-209d-441e-8b92-6515d7a0c369" />

<table>
  <tr>
    <td width="50%" align="center">
      <img width="2940" height="1848" alt="Light mode with full profile support" src="https://github.com/user-attachments/assets/4ef3a59c-7a66-4705-b4e7-cb9148fe4c47" />
      <br /><sub>Light mode with full profile support</sub>
    </td>
    <td width="50%" align="center">
      <img alt="Customize your settings, configure a password" src="https://github.com/user-attachments/assets/941f3156-21e3-41fd-bcc8-f975d5000cb8" />
      <br /><sub>Customize your settings, configure a password</sub>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="50%" align="center">
      <img alt="Workspace file browser with inline preview" src="docs/images/ui-workspace.png" />
      <br /><sub>Workspace file browser with inline preview</sub>
    </td>
    <td width="50%" align="center">
      <img alt="Session projects, tags, and tool call cards" src="docs/images/ui-sessions.png" />
      <br /><sub>Session projects, tags, and tool call cards</sub>
    </td>
  </tr>
</table>

This gives you nearly **1:1 parity with Hermes CLI from a convenient web UI** 您可以透過Hermes設定的SSH隧道安全地訪問。 啟動此操作的單個命令，以及在計算機上訪問SSH隧道的單個命令。 網路使用者介面的每個部分都使用您現有的Hermes代理和現有模型，無需任何額外的設定。

---

## Why Hermes

大多數人工智慧工具在每次會話中都會重置。 他們不知道你是誰，你做了什麼，或者什麼

你的專案遵循的慣例。 你每次都會重新解釋自己。

愛馬仕跨會話保留上下文，在您離線時執行計劃作業，並獲取

執行的時間越長，你的環境就越聰明。 它使用您現有的愛馬仕代理設定，

您現有的模型，無需額外的配置即可啟動。

是什麼讓它與其他代理工具不同：
- **持久記憶體** — 使用者配置檔案、代理筆記和可重複使用的技能系統

程式；Hermes瞭解您的環境，不必重新學習

- **自託管排程** — 在您離線時觸發的cron作業，提供結果

Telegram、Discord、Slack、Signal、電子郵件等

- **10多個訊息平臺** — 終端中可用的同一代理可以從您的手機聯絡到
- **Self-improving skills** — Hermes根據經驗自動編寫和儲存自己的技能；

沒有市場可以瀏覽，沒有外掛可以安裝

- **編組其他代理** — 可以為繁重的編碼任務生成Claude Code或Codex，並帶來

結果回到它自己的記憶中

- **自託管** — 您的對話、您的記憶、您的硬體

**Vs. the field** *（景觀正在積極移動——請參閱[HERMES.md]（HERMES.md）瞭解完整明細）*：

| | OpenClaw | Claude Code | Codex CLI | OpenCode | Hermes |

|---|---|---|---|---|---|---|

| 持久記憶體（自動） | 是 | 部分† | 部分 | 部分 | 是 |

| 預定工作（自託管） | 是 | 否‡ | 否 | 否 | 是 |

|訊息應用程式訪問|是（15+平臺）|部分（Telegram/Discord預覽）|否|否|是（10+）|

| 網頁使用者介面（自託管） | 僅儀表板 | 否 | 否 | 是 | 是 |

| 自我改進技能 | 部分 | 否 | 否 | 否 | 是 |

| Python/ML生態系統|否（Node.js）|否|否|否|是|

| 提供商不可知 | 是 | 否（僅限克勞德） | 是 | 是 | 是 |

| 開源 | 是（麻省理工學院） | 否 | 是 | 是 | 是 |

†Claude Code具有CLAUDE.md/MEMORY.md專案上下文和滾動自動記憶體，但不是全自動跨會話呼叫

‡ Claude Code具有雲管理的排程（人類基礎設施）和會話範圍的`/loop`；沒有自託管的cron

**最接近的競爭對手是OpenClaw**——兩者都是始終開啟的、自託管的開源代理

帶有記憶體、cron和訊息傳遞。 關鍵區別：Hermes編寫並儲存自己的技能

自動作為核心行為（OpenClaw的技能系統以社群市場為中心）；

Hermes在更新中更加穩定（OpenClaw記錄了釋出迴歸和ClawHub

發生了涉及惡意技能的安全事件）；Hermes在Python中原生執行
生態系統。 請參閱[HERMES.md]（HERMES.md）檢視完整的並排。

---

## 快速啟動

執行回購引導：

```bash
git clone https://github.com/nesquena/hermes-webui.git hermes-webui
cd hermes-webui
python3 bootstrap.py
```

Or keep using the shell launcher:

```bash
./start.sh
```

For self-hosted VM or homelab installs, `ctl.sh` wraps the common daemon lifecycle commands without requiring `fuser` or `pkill`:

```bash
./ctl.sh start              # background daemon, PID at ~/.hermes/webui.pid
./ctl.sh status             # PID, uptime, bound host/port, log path, /health
./ctl.sh logs --lines 100   # tail ~/.hermes/webui.log
./ctl.sh restart
./ctl.sh stop
```

`ctl.sh start` runs the bootstrap in foreground/no-browser mode behind the daemon wrapper, writes logs to `~/.hermes/webui.log`, and respects `.env` plus inline overrides such as `HERMES_WEBUI_HOST=0.0.0.0 ./ctl.sh start`.

The bootstrap will:

1. Detect Hermes Agent and, if missing, attempt the official installer (`curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash`).
2. Find or create a Python environment with the WebUI dependencies.
3. Start the web server and wait for `/health`.
4. Open the browser unless you pass `--no-browser`.
5. Drop you into a first-run onboarding wizard inside the WebUI.

> Native Windows is not supported for this bootstrap yet. Use Linux, macOS, or WSL2.
> For Windows / WSL auto-start at login, see [`docs/wsl-autostart.md`](docs/wsl-autostart.md).

如果安裝後提供商設定仍然不完整，入職嚮導將指示您使用「hermes model」完成它，而不是嘗試在瀏覽器中複製完整的CLI設定。

---

## 碼頭工人

**預建影象**（amd64 + arm64）在每次釋出時都會發布到GHCR。

有關涵蓋所有3個編寫檔案、常見故障模式和繫結掛載遷移的全面設定指南，see [`docs/docker.md`]（Docs/docker.md）。 README涵蓋了5分鐘的快樂之路。

### 5分鐘快速啟動（單個容器）

最簡單的設定：一個在程序中執行代理的WebUI容器。

```bash
git clone https://github.com/nesquena/hermes-webui
cd hermes-webui
cp .env.docker.example .env
# Edit .env if your host UID isn't 1000 (e.g. macOS where UIDs start at 501)
docker compose up -d
# Open http://localhost:8787
```
容器從已安裝的`~/.hermes`卷中自動檢測您的UID/GID，因此代理寫入的檔案可以在主機上讀取。

啟用密碼保護（如果您將埠暴露在`127.0.0.1`之外，則需要）：

```bash
echo "HERMES_WEBUI_PASSWORD=change-me-to-something-strong" >> .env
docker compose up -d --force-recreate
```

### Manual `docker run` (no compose)

```bash
docker pull ghcr.io/nesquena/hermes-webui:latest
docker run -d \
  -e WANTED_UID=$(id -u) -e WANTED_GID=$(id -g) \
  -v ~/.hermes:/home/hermeswebui/.hermes \
  -e HERMES_WEBUI_STATE_DIR=/home/hermeswebui/.hermes/webui \
  -v ~/workspace:/workspace \
  -p 127.0.0.1:8787:8787 \
  ghcr.io/nesquena/hermes-webui:latest
```

### Build locally

```bash
docker build -t hermes-webui .
docker run -d \
  -e WANTED_UID=$(id -u) -e WANTED_GID=$(id -g) \
  -v ~/.hermes:/home/hermeswebui/.hermes \
  -e HERMES_WEBUI_STATE_DIR=/home/hermeswebui/.hermes/webui \
  -v ~/workspace:/workspace \
  -p 127.0.0.1:8787:8787 \
  hermes-webui
```
### 多容器設定

如果您希望代理和WebUI放在單獨的容器中（用於隔離，或者因為您已經在其他地方執行代理閘道器）：

```bash
# Agent + WebUI
docker compose -f docker-compose.two-container.yml up -d

# Agent + Dashboard + WebUI
docker compose -f docker-compose.three-container.yml up -d
```

預設情況下，兩個編譯檔案都使用**命名的Docker卷**，這透過構建解決了UID/GID問題。 如果您需要繫結掛載來共享現有主機目錄，請參閱[`docs/docker.md`](docs/docker.md)瞭解完整的遷移配方。

> **已知限制（#681）**：在雙容器設定中，由WebUI觸發的工具在**WebUI容器**中執行，而不是代理容器。 如果您在WebUI的檔案系統上需要git/node/etc.，請使用單容器設定，擴充套件WebUI Dockerfile，或使用社群[多合一影象](https://github.com/sunnysktsang/hermes-suite).

### 常見故障模式

| 聊天中找不到`git：命令` | 雙容器架構限制（#681） | 使用單容器或擴充套件Dockerfile |

| WebUI找不到代理源 | 「hermes-agent-src」卷配置錯誤 | 按原聲使用合成檔案中的命名卷 |

| Podman共享`.hermes`失敗|Podman 3.4`keep-id`限制|使用Podman 4+或單容器|

有關其中每一個的深入瞭解，請參閱[`docs/docker.md`](docs/docker.md)。

> **注意：**預設情況下，Docker Compose繫結到`127.0.0.1`（僅限本地主機）。

>要在網路上公開，請在「docker-compose.yml」中將埠更改為「8787:8787」

>並設定`HERMES_WEBUI_PASSWORD`以啟用身份驗證。

---

## start.sh自動發現什麼

| 事物 | 它是如何找到它的 |

|---|---|

| Hermes agent dir | `HERMES_WEBUI_AGENT_DIR` env，然後是`~/.hermes/hermes-agent`，然後是兄弟姐妹`../hermes-agent` |

| Python可執行檔案 | 先是代理venv，然後是這個repo中的`.venv`，然後是系統`python3` |

| 國家目錄 | `HERMES_WEBUI_STATE_DIR` env，然後 `~/.hermes/webui-mvp` |

| 預設工作區 | `HERMES_WEBUI_DEFAULT_WORKSPACE` env，然後是`~/workspace`，然後是狀態目錄 |

| 埠 | `HERMES_WEBUI_PORT` env或第一個引數，預設`8787` |

如果發現找到了一切，就不需要其他任何東西了。

---

## 覆蓋（僅當自動檢測錯過時才需要）
```bash
export HERMES_WEBUI_AGENT_DIR=/path/to/hermes-agent
export HERMES_WEBUI_PYTHON=/path/to/python
export HERMES_WEBUI_PORT=9000
export HERMES_WEBUI_AUTO_INSTALL=1  # enable auto-install of agent deps (disabled by default)
./start.sh
```

Or inline:

```bash
HERMES_WEBUI_AGENT_DIR=/custom/path ./start.sh 9000
```

Full list of environment variables:

| Variable | Default | Description |
|---|---|---|
| `HERMES_WEBUI_AGENT_DIR` | auto-discovered | Path to the hermes-agent checkout |
| `HERMES_WEBUI_PYTHON` | auto-discovered | Python executable |
| `HERMES_WEBUI_HOST` | `127.0.0.1` | Bind address (`0.0.0.0` for all IPv4, `::` for all IPv6, `::1` for IPv6 loopback) |
| `HERMES_WEBUI_PORT` | `8787` | Port |
| `HERMES_WEBUI_STATE_DIR` | `~/.hermes/webui-mvp` | Where sessions and state are stored |
| `HERMES_WEBUI_DEFAULT_WORKSPACE` | `~/workspace` | Default workspace |
| `HERMES_WEBUI_DEFAULT_MODEL` | `openai/gpt-5.4-mini` | Default model |
| `HERMES_WEBUI_PASSWORD` | *(unset)* | Set to enable password authentication |
| `HERMES_WEBUI_EXTENSION_DIR` | *(unset)* | Optional local directory served at `/extensions/`; must point to an existing directory before extension injection is enabled |
| `HERMES_WEBUI_EXTENSION_SCRIPT_URLS` | *(unset)* | Optional comma-separated same-origin script URLs to inject; see [WebUI Extensions](docs/EXTENSIONS.md) |
| `HERMES_WEBUI_EXTENSION_STYLESHEET_URLS` | *(unset)* | Optional comma-separated same-origin stylesheet URLs to inject; see [WebUI Extensions](docs/EXTENSIONS.md) |
| `HERMES_HOME` | `~/.hermes` | Base directory for Hermes state (affects all paths) |
| `HERMES_CONFIG_PATH` | `~/.hermes/config.yaml` | Path to Hermes config file |

---

## Accessing from a remote machine

The server binds to `127.0.0.1` by default (loopback only). If you are running
Hermes on a VPS or remote server, use an SSH tunnel from your local machine:

```bash
ssh -N -L <local-port>:127.0.0.1:<remote-port> <user>@<server-host>
```

Example:

```bash
ssh -N -L 8787:127.0.0.1:8787 user@your.server.com
```

Then open `http://localhost:8787` in your local browser.

`start.sh` will print this command for you automatically when it detects you
are running over SSH.

---

## Accessing on your phone with Tailscale

[Tailscale](https://tailscale.com) is a zero-config mesh VPN built on
WireGuard. Install it on your server and your phone, and they join the same
private network -- no port forwarding, no SSH tunnels, no public exposure.

The Hermes Web UI is fully responsive with a mobile-optimized layout
(hamburger sidebar, sidebar top tabs in the drawer, touch-friendly controls),
so it works well as a daily-driver agent interface from your phone.

**Setup:**

1. Install [Tailscale](https://tailscale.com/download) on your server and
   your iPhone/Android.
2. Start the WebUI listening on all interfaces with password auth enabled:

```bash
HERMES_WEBUI_HOST=0.0.0.0 HERMES_WEBUI_PASSWORD=your-secret ./start.sh
```

3. Open `http://<server-tailscale-ip>:8787` in your phone's browser
   (find your server's Tailscale IP in the Tailscale app or with
   `tailscale ip -4` on the server).

That's it. Traffic is encrypted end-to-end by WireGuard, and password auth
protects the UI at the application level. You can add it to your home screen
for an app-like experience.

> **Tip:** If using Docker, set `HERMES_WEBUI_HOST=0.0.0.0` in your
> `docker-compose.yml` environment (already the default) and set
> `HERMES_WEBUI_PASSWORD`.

---

## Manual launch (without start.sh)

If you prefer to launch the server directly:

```bash
cd /path/to/hermes-agent          # or wherever sys.path can find Hermes modules
HERMES_WEBUI_PORT=8787 venv/bin/python /path/to/hermes-webui/server.py
```

Note: use the agent venv Python (or any Python environment that has the Hermes agent dependencies installed). System Python will be missing `openai`, `httpx`, and other required packages.

Health check:

```bash
curl http://127.0.0.1:8787/health
```

---

## Running tests

Tests discover the repo and the Hermes agent dynamically -- no hardcoded paths.

```bash
cd hermes-webui
pytest tests/ -v --timeout=60
```

Or using the agent venv explicitly:

```bash
/path/to/hermes-agent/venv/bin/python -m pytest tests/ -v
```

Tests run against an isolated server on port 8788 with a separate state directory.
Production data and real cron jobs are never touched. Current count: **3309 tests**
across 100+ test files.

---

## Features

### Chat and agent
- Streaming responses via SSE (tokens appear as they are generated)
- Multi-provider model support -- any Hermes API provider (OpenAI, Anthropic, Google, DeepSeek, Nous Portal, OpenRouter, MiniMax, Z.AI); dynamic model dropdown populated from configured keys
- Send a message while one is processing -- it queues automatically
- Edit any past user message inline and regenerate from that point
- Retry the last assistant response with one click
- Cancel a running task directly from the composer footer (Stop button next to Send)
- Tool call cards inline -- each shows the tool name, args, and result snippet; expand/collapse all toggle for multi-tool turns
- Subagent delegation cards -- child agent activity shown with distinct icon and indented border
- Mermaid diagram rendering inline (flowcharts, sequence diagrams, gantt charts)
- Thinking/reasoning display -- collapsible gold-themed cards for Claude extended thinking and o3 reasoning blocks
- Approval card for dangerous shell commands (allow once / session / always / deny)
- SSE auto-reconnect on network blips (SSH tunnel resilience)
- File attachments persist across page reloads
- Message timestamps (HH:MM next to each message, full date on hover)
- Code block copy button with "Copied!" feedback
- Syntax highlighting via Prism.js (Python, JS, bash, JSON, SQL, and more)
- Safe HTML rendering in AI responses (bold, italic, code converted to markdown)
- rAF-throttled token streaming for smoother rendering during long responses
- Context usage indicator in composer footer -- token count, cost, and fill bar (model-aware)

### Sessions
- Create, rename, duplicate, delete, search by title and message content
- Session actions via `⋯` dropdown per session — pin, move to project, archive, duplicate, delete
- Pin/star sessions to the top of the sidebar (gold indicator)
- Archive sessions (hide without deleting, toggle to show)
- Session projects -- named groups with colors for organizing sessions
- Session tags -- add #tag to titles for colored chips and click-to-filter
- Grouped by Today / Yesterday / Earlier in the sidebar (collapsible date groups)
- Download as Markdown transcript, full JSON export, or import from JSON
- Sessions persist across page reloads and SSH tunnel reconnects
- Browser tab title reflects the active session name
- CLI session bridge -- CLI sessions from hermes-agent's SQLite store appear in the sidebar with a gold "cli" badge; click to import with full history and reply normally
- Token/cost display -- input tokens, output tokens, estimated cost shown per conversation (toggle in Settings or `/usage` command)

### Workspace file browser
- Directory tree with expand/collapse (single-click toggles, double-click navigates)
- Breadcrumb navigation with clickable path segments
- Preview text, code, Markdown (rendered), and images inline
- Edit, create, delete, and rename files; create folders
- Binary file download (auto-detected from server)
- File preview auto-closes on directory navigation (with unsaved-edit guard)
- Git detection -- branch name and dirty file count badge in workspace header
- Right panel is drag-resizable
- Syntax highlighted code preview (Prism.js)

### Voice input
- Microphone button in the composer (Web Speech API)
- Tap to record, tap again or send to stop
- Live interim transcription appears in the textarea
- Auto-stops after ~2s of silence
- Appends to existing textarea content (doesn't replace)
- Hidden when browser doesn't support Web Speech API (Chrome, Edge, Safari)

### Profiles
- Profile chip in the **composer footer** -- dropdown showing all profiles with gateway status and model info
- Gateway status dots (green = running), model info, skill count per profile
- Profiles management panel -- create, switch, and delete profiles from the sidebar
- Clone config from active profile on create
- Optional custom endpoint fields on create -- Base URL and API key written into the profile's `config.yaml` at creation time, so Ollama, LMStudio, and other local endpoints can be configured without editing files manually
- Seamless switching -- no server restart; reloads config, skills, memory, cron, models
- Per-session profile tracking (records which profile was active at creation)

### Authentication and security
- Optional password auth -- off by default, zero friction for localhost
- Enable via `HERMES_WEBUI_PASSWORD` env var or Settings panel
- Signed HMAC HTTP-only cookie with 24h TTL
- Minimal dark-themed login page at `/login`
- Security headers on all responses (X-Content-Type-Options, X-Frame-Options, Referrer-Policy)
- 20MB POST body size limit
- CDN resources pinned with SRI integrity hashes

### Themes
- 7 built-in themes: Dark (default), Light, Slate, Solarized Dark, Monokai, Nord, OLED
- Switch via Settings panel dropdown (instant live preview) or `/theme` command
- Persists across reloads (server-side in settings.json + localStorage for flicker-free loading)
- Custom themes: define a `:root[data-theme="name"]` CSS block and it works — see [THEMES.md](THEMES.md)

### Settings and configuration
- **Hermes Control Center** (sidebar launcher button) -- Conversation tab (export/import/clear), Preferences tab (model, send key, theme, language, all toggles), System tab (version, password)
- Send key: Enter (default) or Ctrl/Cmd+Enter
- Show/hide CLI sessions toggle (enabled by default)
- Token usage display toggle (off by default, also via `/usage` command)
- Control Center always opens on the Conversation tab; resets on close
- Unsaved changes guard -- discard/save prompt when closing with unpersisted changes
- Cron completion alerts -- toast notifications and unread badge on Tasks tab
- Background agent error alerts -- banner when a non-active session encounters an error

### Slash commands
- Type `/` in the composer for autocomplete dropdown
- Built-in: `/help`, `/clear`, `/compress [focus topic]`, `/compact` (alias), `/model <name>`, `/workspace <name>`, `/new`, `/usage`, `/theme`
- Arrow keys navigate, Tab/Enter select, Escape closes
- Unrecognized commands pass through to the agent

### Panels
- **Chat** -- session list, search, pin, archive, projects, new conversation
- **Tasks** -- view, create, edit, run, pause/resume, delete cron jobs; run history; completion alerts
- **Skills** -- list all skills by category, search, preview, create/edit/delete; linked files viewer
- **Memory** -- view and edit MEMORY.md and USER.md inline
- **Profiles** -- create, switch, delete agent profiles; clone config
- **Todos** -- live task list from the current session
- **Spaces** -- add, rename, remove workspaces; quick-switch from topbar

### Mobile responsive
- Hamburger sidebar -- slide-in overlay on mobile (<640px)
- Sidebar top tabs stay available on mobile; no fixed bottom nav stealing chat height
- Files slide-over panel from right edge
- Touch targets minimum 44px on all interactive elements
- Full-height chat/composer on phones without bottom-nav spacing
- Desktop layout completely unchanged

---

## Architecture

```
server.py               HTTP routing shell + auth middleware (~154 lines)
api/
  auth.py               Optional password authentication, signed cookies (~201 lines)
  config.py             Discovery, globals, model detection, reloadable config (~1110 lines)
  helpers.py            HTTP helpers, security headers (~175 lines)
  models.py             Session model + CRUD + CLI bridge (~377 lines)
  onboarding.py         First-run onboarding wizard, OAuth provider support (~507 lines)
  profiles.py           Profile state management, hermes_cli wrapper (~411 lines)
  routes.py             All GET + POST route handlers (~2250 lines)
  state_sync.py         /insights sync — message_count to state.db (~113 lines)
  streaming.py          SSE engine, run_agent, cancel support (~660 lines)
  updates.py            Self-update check and release notes (~257 lines)
  upload.py             Multipart parser, file upload handler (~82 lines)
  workspace.py          File ops, workspace helpers, git detection (~288 lines)
static/
  index.html            HTML template (~600 lines)
  style.css             All CSS incl. mobile responsive, themes (~1050 lines)
  ui.js                 DOM helpers, renderMd, tool cards, context indicator (~1740 lines)
  workspace.js          File preview, file ops, git badge (~286 lines)
  sessions.js           Session CRUD, collapsible groups, search, reload recovery (~800 lines)
  messages.js           send(), SSE handlers, live streaming, session recovery (~655 lines)
  panels.js             Cron, skills, memory, profiles, settings (~1438 lines)
  commands.js           Slash command autocomplete (~267 lines)
  boot.js               Mobile nav, voice input, boot IIFE (~524 lines)
tests/
  conftest.py           Isolated test server (port 8788)
  61 test files          961 test functions
Dockerfile              python:3.12-slim container image
docker-compose.yml      Compose with named volume and optional auth
.github/workflows/      CI: multi-arch Docker build + GitHub Release on tag
```

State lives outside the repo at `~/.hermes/webui-mvp/` by default
(sessions, workspaces, settings, projects, last_workspace). Override with `HERMES_WEBUI_STATE_DIR`.

---

## Docs

- `HERMES.md` -- why Hermes, mental model, and detailed comparison to Claude Code / Codex / OpenCode / Cursor
- `ROADMAP.md` -- feature roadmap and sprint history
- `ARCHITECTURE.md` -- system design, all API endpoints, implementation notes
- `TESTING.md` -- manual browser test plan and automated coverage reference
- `CHANGELOG.md` -- release notes per sprint
- `SPRINTS.md` -- forward sprint plan with CLI + Claude parity targets
- `THEMES.md` -- theme system documentation, custom theme guide
- `docs/troubleshooting.md` -- diagnostic flows for common failures (e.g. "AIAgent not available")

## Contributors

Hermes WebUI is built with help from the open-source community. Every PR — whether merged directly or incorporated via batch release — shapes the project, and we're grateful to everyone who has taken the time to contribute.

**66 contributors have shipped code that landed in a release tag** as of v0.50.245. The full credit roll lives in [`CONTRIBUTORS.md`](CONTRIBUTORS.md). The highlights:

### Top contributors (by merged-PR count)

| # | Contributor | PRs | First → latest release |
|---|---|---:|---|
| 1 | [@franksong2702](https://github.com/franksong2702) | 22 | `v0.50.49` → `v0.50.245` |
| 2 | [@bergeouss](https://github.com/bergeouss) | 18 | `v0.50.49` → `v0.50.240` |
| 3 | [@aronprins](https://github.com/aronprins) | 8 | `v0.47.0` → `v0.50.77` |
| 4 | [@iRonin](https://github.com/iRonin) | 6 | `v0.41.0` |
| 5 | [@24601](https://github.com/24601) | 6 | `v0.50.201` |
| 6 | [@KingBoyAndGirl](https://github.com/KingBoyAndGirl) | 4 | `v0.50.232` → `v0.50.237` |
| 7 | [@renheqiang](https://github.com/renheqiang) | 4 | `v0.50.93` |
| 8 | [@ccqqlo](https://github.com/ccqqlo) | 3 | `v0.50.83` → `v0.50.207` |
| 9 | [@deboste](https://github.com/deboste) | 3 | `v0.16.1` |
| 10 | [@frap129](https://github.com/frap129) | 3 | `v0.50.157` → `v0.50.166` |

See [`CONTRIBUTORS.md`](CONTRIBUTORS.md) for the full ranked list of all 66 contributors, including everyone with one or two merged PRs and the special-thanks roll for design and architectural contributions.

### Notable contributions

**[@aronprins](https://github.com/aronprins)** — v0.50.0 UI overhaul (PR #242)
The biggest single contribution to the project: a complete UI redesign that moved model/profile/workspace controls into the composer footer, replaced the gear-icon settings panel with the Hermes Control Center (tabbed modal), removed the activity bar in favor of inline composer status, redesigned the session list with a `⋯` action dropdown, and added the workspace panel state machine. 26 commits, thoroughly designed and iterated through multiple review rounds.

**[@iRonin](https://github.com/iRonin)** — Security hardening sprint (PRs #196–#204)
Six consecutive security and reliability PRs: session memory leak fix (expired token pruning), Content-Security-Policy + Permissions-Policy headers, 30-second slow-client connection timeout, optional HTTPS/TLS support via environment variables, upstream branch tracking fix for self-update, and CLI session support in the file browser API. This is the kind of focused, high-quality security work that makes a self-hosted tool trustworthy.

**[@DavidSchuchert](https://github.com/DavidSchuchert)** — German translation (PR #190)
Complete German locale (`de`) covering all UI strings, settings labels, commands, and system messages — and in doing so, stress-tested the i18n system and exposed several elements that weren't yet translatable, which got fixed as part of the same PR.

**[@Jordan-SkyLF](https://github.com/Jordan-SkyLF)** — Live streaming, session recovery, workspace fallback (PRs #366, #367)
Three interlocking improvements: workspace fallback resolution so the server recovers gracefully when the configured workspace is deleted or unavailable; live reasoning cards that upgrade the generic thinking spinner to a real-time reasoning display as the model thinks; and durable session state recovery via `localStorage` so in-flight tool cards, partial assistant output, and the live SSE stream all survive a full page reload or session switch.

### Feature contributions

**[@gabogabucho](https://github.com/gabogabucho)** — Spanish locale + onboarding 嚮導（PRs #275，#285）

最初的三個社群PR：修復了EventSource/fetch，以使用URL來源進行反向代理設定，從配置中更正模型提供商路由，並添加了帶有dvh視口修復的移動響應佈局。 早期基礎工作。

###錯誤修復和安全貢獻

**[@Hinotoi-agent](https://github.com/Hinotoi-agent)** — 個人資料.env秘密隔離（PR #351）

修復了交換機上配置檔案之間的API金鑰洩漏——從帶有「OPENAI_API_KEY」的配置檔案切換到沒有它的配置檔案，在會話期間將金鑰留在流程環境中，有效地洩露了憑據。 一個微妙而重要的安全修復。

**[@Lawrencel1ng](https://github.com/lawrencel1ng)** — 強盜安全修復B310/B324/B110 + QuietHTTPServer（PR #354）

系統的強盜安全掃描修復：在「urlopen」之前進行URL方案驗證，MD5「usedforsecurity=False」，以及40多個裸「except: pass」塊被替換為適當的日誌記錄——加上「QuietHTTPServer」，以阻止來自SSE流的客戶端斷開日誌垃圾郵件。
**[@lx3133584]（Https://github.com/lx3133584）** — 非標準埠上反向代理的CSRF修復（PR #360）

修復了在非標準埠上Nginx代理管理器或類似部署的CSRF拒絕問題——對於在80/443以外的埠上託管的任何人來說，這是一個現實世界的障礙。

**[@DelightRun](https://github.com/DelightRun)** — WebUI會話的session_search修復（PR #356）

「session_search」工具在每個WebUI會話中都無聲地返回「會話資料庫不可用」。 追蹤了流路徑中缺失的「SessionDB」注入，並修復了它。

**[@Shaoxianbilly](https://github.com/shaoxianbilly)** — Unicode檔名下載（PR #378）

修復了下載中文、日語或其他非ASCII名稱的工作區檔案時的「UnicodeEncodeError」崩潰。 使用RFC 5987 `filename*=UTF-8''...`編碼實現適當的`Content-Disposition`標題。

**[@Huangzt](https://github.com/huangzt)** — 取消中斷代理（PR #244）

使「取消」按鈕實際上中斷了正在執行的代理並清理了UI狀態，而不僅僅是在代理繼續執行時隱藏了按鈕。

**[@Tgaalman](https://github.com/tgaalman)** — 思考卡修復（PR #169）

修復了思維卡顯示中遺漏的頂級推理欄位——克勞德的擴充套件思維塊如何在API響應中浮出水面的邊緣案例。

**[@Smurmann](https://github.com/smurmann)** — 自定義提供商路由修復（PR #189）

「」
