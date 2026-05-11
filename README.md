# Gion Local Core

Gion Local Core 是 Hermes / Gion 本機核心的 **canonical main branch** 基線。這個分支的目的不是同時支援多種實驗部署，而是提供一套可閱讀、可驗證、可回復的單人本機安裝流程。

## 專案定位

- **唯一正式安裝來源**：根目錄的 `docker-compose.yml`。
- **本機優先**：WebUI 預設只綁定 `127.0.0.1:8787`，避免未授權的區域網路或公網存取。
- **透明資料目錄**：所有本機狀態、設定、工作區與 WebUI history 預設存放於主機 `~/Hermes_Gion_Core`。
- **實驗歸檔**：`archive/` 只保存多容器實驗與歷史範例，不納入 main branch 安裝流程。
- **可治理**：提供 `validate.sh` 與 `smoke.sh`，用於本機檢查與快速啟動測試。
- **價值導向**：以自主、共生、協作、傳承與善意共振作為核心理念，並把「技術變回人的節奏」作為源起，詳見 `VALUES.md`。

## 目錄結構

```text
.
├── README.md
├── SPEC.md
├── VALUES.md
├── docker-compose.yml
├── .env.example
├── requirements.txt
├── start.sh
├── bootstrap.py
├── validate.sh
├── smoke.sh
├── scripts/
│   ├── validate.sh
│   └── smoke.sh
└── archive/
    ├── README.md
    └── docker/
        ├── README.md
        ├── docker-compose.two-container.yml
        └── docker-compose.three-container.yml
```

## 快速開始

### 1. 準備環境

需求：

- Docker Engine 與 Docker Compose v2
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

- WebUI container 內的 Hermes data path 是 `/home/hermeswebui/.hermes`，對應 host 的 `HERMES_HOME`。
- WebUI container 內的 workspace path 是 `/workspace`，對應 host 的 `HERMES_WORKSPACE`。
- 若要用 `./start.sh` 在 host 前景執行本機 Python WebUI source，請另設 `HERMES_WEBUI_SOURCE_DIR` 指向含有 `server.py` 的 WebUI source tree；不要假設這個 gion-local-core repo 內一定有 `server.py`。

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
- `archive/` 中的多容器範例不承諾安全更新，不應直接作為正式安裝流程。
- `.env` 可能包含密碼或 API key，必須保留在本機，不可提交。

## 驗證與測試

檢查必需檔案、Python syntax、Docker Compose render 與 archive 邊界：

```bash
./validate.sh
```

進行 Docker 快速啟動 smoke test：

```bash
./smoke.sh
```

`scripts/` 內保留實作檔；根目錄 `validate.sh` 與 `smoke.sh` 是給使用者直接執行的穩定入口。

## archive 是否納入安裝流程？

不納入。

`archive/docker/docker-compose.two-container.yml` 與 `archive/docker/docker-compose.three-container.yml` 只保留作為多容器架構評估與歷史參考。main branch 的正式安裝、文件與測試只以根目錄 `docker-compose.yml` 為準。

## 相關文件

- `SPEC.md`：治理規格、安裝邊界、資料路徑與安全要求。
- `VALUES.md`：核心理念、協作價值與倫理邊界。
- `docs/docker.md`：Docker 使用補充說明。
- `docs/gion-local-core-v26.md`：多節點本地核心前瞻架構規格。
- `archive/README.md`：歸檔政策。
