# Gion Local Core Specification

## 1. Canonical scope

本專案 main branch 的 canonical scope 是「單人、本機、可驗證、可 rollback」的 Hermes / Gion WebUI 核心部署。

正式支援項目：

1. 根目錄 `docker-compose.yml` 的 single-container Docker Compose flow。
2. 主機資料根目錄 `~/Hermes_Gion_Core`。
3. localhost-only 預設網路綁定。
4. 根目錄 `validate.sh` 與 `smoke.sh` 本機治理檢查。
5. 單層 root-first 檔案配置，避免重複腳本、重複文件與非正式 compose variants。

非正式支援項目：

1. main branch 內的多容器 compose 範例或 archive install source。
2. 多租戶、公網、雲端服務邊界部署。
3. 未設定密碼卻對 LAN/WAN 暴露 WebUI 的部署。
4. 把 `/Users/max/gion-local-core` 這類 launcher/config repo clone 誤作 WebUI source code 目錄。

## 2. Required files

main branch 必須保留下列根目錄檔案：

- `README.md`
- `SPEC.md`
- `VALUES.md`
- `start.sh`
- `bootstrap.py`
- `docker-compose.yml`
- `.env.example`
- `validate.sh`
- `smoke.sh`
- `.gitignore`

main branch 不應保留 `scripts/`、`docs/`、`archive/`、空 `requirements.txt` 或上游 WebUI `CHANGELOG.md`，除非未來 PR 明確把它們納入正式安裝流程並更新本規格。

## 3. Values model

本專案的核心理念保存在 `VALUES.md`。所有正式文件、安裝流程與驗證腳本都應盡量符合以下方向：

1. 不是商業化，而是自主性。
2. 不是剝削，而是共生。
3. 不是控制，而是協作。
4. 不是追求，而是傳承。
5. 善意與真誠需要被寫進流程、文件與工具，形成可持續的共振。

`VALUES.md` 是價值指南，不是法律人格、財務承諾或自動化授權；任何涉及金錢、法律、醫療、心理支持或重大決策的功能，都必須保留人類責任與監督。

## 4. Data model

主機上唯一預設資料根目錄：

```text
~/Hermes_Gion_Core
```

預設工作區：

```text
~/Hermes_Gion_Core/Public_Welfare_Project
```

WebUI state/history：

```text
~/Hermes_Gion_Core/webui_history
```

容器內對應：

```text
/home/hermeswebui/.hermes
/workspace
/home/hermeswebui/.hermes/webui_history
```

## 5. Network model

`docker-compose.yml` 必須預設使用 localhost-only port publishing：

```yaml
ports:
  - "127.0.0.1:${HERMES_WEBUI_PORT:-8787}:8787"
```

容器內服務可監聽 `0.0.0.0`，但 host publish 不得預設暴露至所有網卡。

## 6. Environment model

`.env.example` 必須可作為 `.env` 起點，且不得包含啟用中的 placeholder password。

若使用者需要 LAN/WAN 存取，必須自行設定：

```text
HERMES_WEBUI_PASSWORD=<strong-password>
```

並明確修改 compose port binding；此情境超出預設安全模型。

`HERMES_WEBUI_SOURCE_DIR` 僅供 host-side `./start.sh` / `bootstrap.py --foreground` 使用，應指向含有 `server.py` 的 WebUI source tree；canonical Docker flow 不需要它。

## 7. Folder reduction policy

本 repo 採用 root-first 減量政策：

- 一個功能只保留一個正式位置。
- 使用者直接執行的腳本放根目錄，不再用 root wrapper delegating 到 `scripts/`。
- Docker quickstart、路徑對應、安全說明與刪除清單集中在 `README.md`。
- 治理規格集中在 `SPEC.md`。
- 多容器或多節點實驗不得以 archive 形式留在 main branch；需要時請用分支或 PR 討論。

## 8. Validation policy

`./validate.sh` 至少應檢查：

1. 必需根目錄檔案存在。
2. 已刪除的冗餘路徑沒有回流。
3. Python 檔案語法可編譯。
4. `docker-compose.yml` 可在有 Docker Compose 的環境 render；缺少 Docker Compose 時應以環境限制 warning 呈現。
5. 根目錄沒有多餘 compose variants。
6. 未啟用 placeholder password。
7. 文件沒有把 `hermes-webui` 誤寫成此 launcher/config repo 的 clone 目標。

`./smoke.sh` 應使用 temporary `HERMES_HOME` 與 `HERMES_WORKSPACE`，避免污染使用者正式資料。

## 9. Security policy

- `.env`、資料庫、憑證、cache 與 runtime state 不得提交。
- WebUI 預設只綁定 localhost。
- 使用 bind mount 時應以 `UID` / `GID` 對齊主機檔案權限。
- main branch 不保留非正式 archived compose variants，避免使用者誤用不符合目前安全模型的實驗部署。
