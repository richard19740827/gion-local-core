# Gion Local Core Specification

## 1. Canonical scope

本專案 main branch 的 canonical scope 是「單人、本機、可驗證、可 rollback」的 Hermes / Gion WebUI 核心部署。

正式支援項目：

1. 根目錄 `docker-compose.yml` 的 single-container Docker Compose flow。
2. 主機資料根目錄 `~/Hermes_Gion_Core`。
3. localhost-only 預設網路綁定。
4. `validate.sh` 與 `smoke.sh` 本機治理檢查。

非正式支援項目：

1. `archive/` 內任何多容器 compose 範例。
2. 多租戶、公網、雲端服務邊界部署。
3. 未設定密碼卻對 LAN/WAN 暴露 WebUI 的部署。

## 2. Required files

main branch 必須保留下列檔案：

- `README.md`
- `SPEC.md`
- `start.sh`
- `bootstrap.py`
- `requirements.txt`
- `docker-compose.yml`
- `.env.example`
- `validate.sh`
- `smoke.sh`
- `.gitignore`
- `archive/README.md`
- `archive/docker/README.md`
- `archive/docker/docker-compose.two-container.yml`
- `archive/docker/docker-compose.three-container.yml`

## 3. Data model

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

## 4. Network model

`docker-compose.yml` 必須預設使用 localhost-only port publishing：

```yaml
ports:
  - "127.0.0.1:8787:8787"
```

容器內服務可監聽 `0.0.0.0`，但 host publish 不得預設暴露至所有網卡。

## 5. Environment model

`.env.example` 必須可作為 `.env` 起點，且不得包含啟用中的 placeholder password。

若使用者需要 LAN/WAN 存取，必須自行設定：

```text
HERMES_WEBUI_PASSWORD=<strong-password>
```

並明確修改 compose port binding；此情境超出預設安全模型。

## 6. Archive policy

`archive/` 是 historical reference，不是 install source。

歸檔檔案可用於：

- 回溯多容器實驗設計。
- 比較 agent/dashboard/webui 分離架構。
- 日後重新評估是否升級為正式流程。

歸檔檔案不可用於：

- README quickstart。
- smoke test canonical runtime。
- main branch 預設安裝流程。

## 7. Validation policy

`./validate.sh` 至少應檢查：

1. 必需檔案存在。
2. Python 檔案語法可編譯。
3. `docker-compose.yml` 可 render。
4. 根目錄沒有多餘 compose variants。
5. `archive/` 目錄名稱與檔案位置正確。
6. 未啟用 placeholder password。

`./smoke.sh` 應使用 temporary `HERMES_HOME` 與 `HERMES_WORKSPACE`，避免污染使用者正式資料。

## 8. Security policy

- `.env`、資料庫、憑證、cache 與 runtime state 不得提交。
- WebUI 預設只綁定 localhost。
- 使用 bind mount 時應以 `UID` / `GID` 對齊主機檔案權限。
- `archive/` 範例不承諾符合目前安全模型。
