# Gion Local Core

Gion Local Core 是 Hermes / Gion 本機核心的 **canonical single-folder launcher/config repo**。這個分支的目的不是同時保存多套實驗部署，而是提供一套可閱讀、可驗證、可回復的單人本機安裝流程。

## 專案定位

- **唯一正式安裝來源**：根目錄的 `docker-compose.yml`。
- **單層資料夾治理**：正式入口、文件與腳本都放在 repo 根目錄，避免 `scripts/`、`docs/`、`archive/` 內出現功能雷同或不會被安裝流程使用的檔案。
- **本機優先**：WebUI 預設只綁定 `127.0.0.1:8787`，避免未授權的區域網路或公網存取。
- **透明資料目錄**：所有本機狀態、設定、工作區與 WebUI history 預設存放於主機 `~/Hermes_Gion_Core`。
- **可治理**：提供根目錄 `validate.sh` 與 `smoke.sh`，用於本機檢查與快速啟動測試。
- **價值導向**：以自主、共生、協作、傳承與善意共振作為核心理念，並把「技術變回人的節奏」作為源起，詳見 `VALUES.md`。

## 目錄結構

正式檔案保持在 repo 根目錄：

```text
.
├── README.md
├── SPEC.md
├── VALUES.md
├── docker-compose.yml
├── .env.example
├── start.sh
├── bootstrap.py
├── validate.sh
└── smoke.sh
```

## 本次資料夾減量與刪除清單

為避免「相同功能散落在不同資料夾」與「未被 canonical install flow 使用的檔案」造成混淆，已刪除下列項目：

| 已刪除項目 | 原用途 | 刪除原因 |
|---|---|---|
| `scripts/validate.sh`、`scripts/smoke.sh` 與 `scripts/` | root wrapper 的實作來源 | 已把實作收斂到根目錄 `validate.sh` / `smoke.sh`，避免同一功能有兩個位置。 |
| `docs/docker.md` 與 `docs/` | Docker 補充文件 | Docker quickstart、路徑對應與安全說明已併入本 README 與 `SPEC.md`。 |
| `docs/gion-local-core-v26.md` | 多節點前瞻設計 | 不屬於目前 single-container launcher 安裝流程；避免把 future architecture 誤認成正式入口。 |
| `archive/docker/*.yml`、`archive/README.md` 與 `archive/` | two-container / three-container 歷史範例 | archive 不再保留在 main branch，避免使用者誤用非正式 compose variants。 |
| `requirements.txt` | 說明 host helper 無 Python dependency | `bootstrap.py` 僅用 Python standard library，文件說明即可，不需要空需求檔。 |
| `CHANGELOG.md` | 上游 WebUI 歷史 changelog | launcher/config repo 沒有使用該上游 changelog，保留會讓專案邊界不清楚。 |

若未來需要重新評估多容器或多節點設計，請另開分支或 PR 討論，不要直接把實驗 compose 放回 main branch 根目錄或新增 archive install source。

## 快速開始

### 1. 準備環境

需求：

- Docker Engine 與 Docker Compose v2（正式 Docker flow 與 smoke test 需要）
- Python 3.10+（用於 `bootstrap.py` 與驗證腳本）
- `curl`

### 2. 建立環境設定

```bash
cp .env.example .env
mkdir -p ~/Hermes_Gion_Core/Public_Welfare_Project
```

macOS 或需要明確檔案權限時，建議把目前使用者 UID/GID 寫入 `.env`：

```bash
echo "UID=$(id -u)" >> .env
echo "GID=$(id -g)" >> .env
```

### 3. 啟動 WebUI

```bash
docker compose up -d
```

開啟：

```text
http://127.0.0.1:8787
```

### 4. 停止與回復

```bash
docker compose down
```

如需移除 compose 建立的附屬資源：

```bash
docker compose down --volumes --remove-orphans
```

## 環境變數

| 變數 | 預設值 | 說明 |
|---|---|---|
| `HERMES_HOME` | `~/Hermes_Gion_Core` | 主機上的 Hermes / Gion 透明資料根目錄。 |
| `HERMES_WORKSPACE` | `~/Hermes_Gion_Core/Public_Welfare_Project` | Host 工作區；Docker 會 mount 到 container 內 `/workspace`。 |
| `HERMES_WEBUI_DEFAULT_WORKSPACE` | host-side 為 `HERMES_WORKSPACE`；Docker container 內為 `/workspace` | WebUI 預設開啟的工作區；不要在 container 內使用 host 絕對路徑。 |
| `HERMES_WEBUI_STATE_DIR` | host-side 為 `~/Hermes_Gion_Core/webui_history`；Docker container 內為 `/home/hermeswebui/.hermes/webui_history` | WebUI 狀態與 history 目錄。 |
| `HERMES_WEBUI_HOST` | `0.0.0.0`（容器內） | 容器內監聽位址；host 端仍由 compose 限制為 `127.0.0.1`。 |
| `HERMES_WEBUI_PORT` | `8787` | WebUI 服務埠。 |
| `HERMES_WEBUI_PASSWORD` | 空 | 若刻意對外暴露服務，必須設定強密碼。 |
| `HERMES_WEBUI_SOURCE_DIR` | repo root | 僅供 `bootstrap.py --foreground` / `./start.sh` host-side 模式使用；應指向含 `server.py` 的 WebUI source tree。 |
| `UID` / `GID` | `1000` | Docker 寫入 bind mount 時使用的主機 UID/GID。 |

## Repo、資料與 WebUI source 對應

若本機 repo clone 在 `/Users/max/gion-local-core`，該路徑代表 launcher/config repository，只用來放 `docker-compose.yml`、`bootstrap.py` 與治理腳本。canonical Docker flow 使用 prebuilt WebUI image，不會把 `/Users/max/gion-local-core` 當成 WebUI source code mount 進 container。

請把三種路徑分開看：

| 類型 | 範例 | 是否 mount 進 container | 說明 |
|---|---|---:|---|
| Repo clone | `/Users/max/gion-local-core` | 否 | 執行 `docker compose`、`./validate.sh`、`./smoke.sh` 的地方。 |
| Persistent data | `~/Hermes_Gion_Core` | 是，mount 到 `/home/hermeswebui/.hermes` | 設定、sessions、credentials、WebUI history。 |
| Workspace | `~/Hermes_Gion_Core/Public_Welfare_Project` | 是，mount 到 `/workspace` | WebUI 內可見與可操作的工作區。 |
| Optional WebUI source | 例如 `/Users/max/hermes-webui` | 僅 host-side `./start.sh` 使用 | 若不用 Docker image、而要以前景模式跑本機 Python `server.py`，才需要設定 `HERMES_WEBUI_SOURCE_DIR`。 |

## 資料存放規則

所有可持久化資料均應放在主機：

```text
~/Hermes_Gion_Core
```

其中常見子目錄：

```text
~/Hermes_Gion_Core/config.yaml
~/Hermes_Gion_Core/webui_history
~/Hermes_Gion_Core/Public_Welfare_Project
```

請勿把 `.env`、資料庫、憑證、cache 或 runtime state 提交到 Git；`.gitignore` 已涵蓋這些路徑。

## 安全考量

- `docker-compose.yml` 預設發布到 `127.0.0.1:8787:8787`，只允許本機瀏覽器存取。
- 若修改為 `0.0.0.0:8787:8787` 或其他對外綁定，請先設定 `HERMES_WEBUI_PASSWORD`，並確認防火牆與網路邊界。
- main branch 不保留 archived compose variants；請勿把多容器實驗檔當成正式安裝流程。
- `.env` 可能包含密碼或 API key，必須保留在本機，不可提交。

## 驗證與測試

檢查必需檔案、Python syntax、Docker Compose render（若環境有 Docker Compose）、文件路徑與減量邊界：

```bash
./validate.sh
```

進行 Docker 快速啟動 smoke test：

```bash
./smoke.sh
```

`validate.sh` 與 `smoke.sh` 都是根目錄直接執行的實作檔；不再透過 `scripts/` wrapper/delegate。

## 相關文件

- `SPEC.md`：治理規格、安裝邊界、資料路徑、安全要求與減量政策。
- `VALUES.md`：核心理念、協作價值與倫理邊界。
