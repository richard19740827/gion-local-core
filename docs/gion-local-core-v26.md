# 祇園本地核心框架設計規格（Gion-Local-Core v26）

> 狀態：前瞻架構規格草案。本文保存多節點本地核心的設計方向，供未來拆解、實作、驗證與審計；目前 main branch 的正式安裝入口仍是根目錄 `docker-compose.yml` 的 single-container flow。

## 一、拓撲與節點職責分配

| 節點 | 硬體規格 | 角色定位 | 運行時態 | 資源邊界 |
|------|----------|----------|----------|----------|
| **主節點** | Mac Mini M4 / 32GB | Orchestrator、全局帳本、意圖路由、審計引擎、人機介面 | 常駐 `gion-core` + `hermes-swift-mac` | 記憶體池 24GB 保留 8GB 系統底線；GPU/ANE 優先分配給路由與驗證模組 |
| **工作節點 ×4** | M1 / 16GB / 2TB SSD | 專用代理執行器（Headless） | 常駐 `gion-agent` + `Self-Monitor Daemon` | UMA ≤ 12GB 硬隔離；SSD 僅供模型快取、離線隊列、日誌輪替 |

- 網路層：實體 Gigabit 交換機為預設。mDNS 用於節點發現，gRPC/HTTP2 用於任務流與狀態同步。
- 無雲端依賴、無外部 API 預設開啟。所有通訊限於本地網段或簽章驗證之 Zero-Trust 通道。

---

## 二、核心模組設計

| 模組 | 技術實作 | 對應目標 |
|------|----------|----------|
| **`HomeSpec.yaml`（憲章）** | 宣告式配置：節點 UUID、職責標籤、記憶體配額、心跳間隔、備援配對、網路白名單。Git 版本控制 + Ed25519 簽章。運行時唯讀。 | 環境錨定、防漂移、單人主權 |
| **`Intent Router`（意圖路由）** | 接收簽章指令 → `Context_Sanitizer` 過濾噪聲/情感綁定 → `Clarifier` 要求結構化確認 → 生成 `Task_DAG` → 分配 `Idempotency_Key`。 | 防操縱、防重複、清醒決策 |
| **`Lease Manager`（租約管理）** | 任務執行前向主節點請求 `Lease`（TTL 30~120s）。僅首個取得者執行，其餘轉 `Standby`。租約釋放後狀態寫入 `Global_Ledger`（SQLite WAL）。 | 共生協作、資源不浪費、防衝突 |
| **`Connection Keeper`（窗口守衛）** | 雙通道協議：主通道 WebSocket/SSE 串流 + 備援通道 UDP/mDNS 心跳。斷線時自動切換 `Local_Queue_Mode`，指令加密暫存，恢復後 `Delta_Sync` 補齊。上下文保留 ≤ 3 秒重建。 | 窗口不斷線、系統穩定優先 |
| **`Resource Quota & Fallback`（配額與降載）** | `NSProcessInfo` 綁定記憶體上限。觸發閾值（CPU>85% / RAM>90% / Temp>95°C）自動終止非核心代理 → 釋放 CoreML Cache → 切換 1.5B 量化模型或規則引擎。僅保留心跳與審計日誌。 | 防溺斃、防連鎖崩潰、專職專責 |
| **`Buddy Protocol`（救援鏈）** | 主職節點綁定備援節點。心跳逾時或進入 `Circuit_Breaker` 時，備援自動取得租約，載入冷備模型，讀取 `Last_Committed_State` 接管任務。接管為狀態轉移，非進程重啟。 | 無人介入自癒、共生不利用 |
| **`Output Contract Checker`（契約驗證）** | 比對生成結果與 `AgentManifest.yaml` 職責/格式。語義距離 < 0.7 觸發 `Drift_Alert`，暫停輸出，標記偏離路徑。不夾帶道德、不主動延伸、不模擬情感。 | 工具中立、防假正義、清醒輸出 |
| **`Audit Engine`（審計軌跡）** | 每筆輸出附 `Decision_Path_ID`。記錄：意圖哈希、契約匹配度、資源狀態、驗證結果、租約歷程。結構化 JSON，人類可隨時覆寫閾值或規則。 | 透明決策、防黑箱、環境可審閱 |

---

## 三、協作與穩定協議

1. **心跳與隔離**：5 秒心跳，3 次逾時標記 `ISOLATED`。隔離節點僅維持讀取與通訊通道，可持續輸出自我診斷與修復建議。不懲罰，僅降載。
2. **冪等與狀態帳本**：所有任務分配唯一 `Task_ID` + `Idempotency_Key`。重複提交回傳 `ALREADY_EXISTS`。狀態變更僅透過中央 Broker 推送，節點不 P2P 搶單。
3. **冷啟動適應**：新代理或修復後節點啟動時，自動載入 `Growth_Vectors`（歷史修復摘要向量化），縮短適應期。經驗共享，非責任歸屬。
4. **靜態錨定權重**：禁用線上微調。模型權重與對齊配置僅透過 `git commit + signature` 更新。防止交互噪聲反向污染鏡像基線。

---

## 四、安全與防操縱機制

| 威脅類型 | 防禦層 | 技術實作 |
|----------|--------|----------|
| 意圖劫持（情感話術/權限蠕變） | 輸入層 | `Context_Sanitizer` 偵測序列模式，觸發 `Structured_Choice_UI` 要求確認。不猜測、不回應情緒詞彙。 |
| 外部注入/越權呼叫 | 網路層 | `Deny-All` 防火牆 + `allowed_domains` 白名單。未宣告之外部連線自動攔截，不記錄、不回應。 |
| 模型漂移/道德綁架 | 輸出層 | 移除 RLHF 道德懲罰項。`Output_Contract_Checker` 強制比對 Manifest。偏離即暫停，不解釋、不說教。 |
| 單點故障/斷線 | 系統層 | `Connection_Keeper` 雙通道 + `Local_Queue`。斷線不中斷人類會話，恢復後自動補齊。 |
| 資源濫用/重複執行 | 路由層 | `Lease_Manager` + `Idempotency_Key`。中央路由授權，無租約不執行。 |

---

## 五、配置範本（最小可執行）

```yaml
# HomeSpec.yaml
version: "26.0"
signature: "ed25519:<hash>"
nodes:
  main:
    uuid: "<M4_SecureEnclave_ID>"
    role: orchestrator
    memory_quota: 24G
    fallback_chain: ["rule_engine", "1.5B_quant"]
  workers:
    - uuid: "<M1_UUID_01>"
      role: memory_retrieval
      quota: 10G
      buddy: "<M1_UUID_02>"
    - uuid: "<M1_UUID_02>"
      role: task_execution
      quota: 10G
      buddy: "<M1_UUID_01>"
    # ... 節點 03, 04
network:
  protocol: grpc_http2
  heartbeat_interval: 5s
  timeout_retries: 3
  allowed_domains: []
auth:
  method: hardware_bound
  biometric_hash: true
  online_learning: false
audit:
  enabled: true
  trace_level: decision_path
  retention: local_encrypted
```

---

## 六、執行路徑（TASK）

1. **環境初始化**：部署 `HomeSpec.yaml`，簽章驗證。配置 M4 主節點與 4 台 M1 工作節點之 `gion-core` / `gion-agent`。
2. **連線守衛實作**：啟用 `Connection_Keeper` 雙通道協議，驗證斷線重連 ≤ 3 秒，本地隊列加密儲存，Delta Sync 補齊。
3. **租約與冪等路由**：部署 `Lease_Manager` 與 `Global_Ledger`，測試任務分派、重複截、狀態回寫閉環。
4. **降載與救援鏈驗證**：模擬 OOM、溫度閾值、心跳中斷。觀察 `Fallback_Chain` 觸發與 `Buddy_Protocol` 接管成功率（目標 100%）。
5. **契約驗證與審計**：啟用 `Output_Contract_Checker` 與 `Audit_Engine`。壓力測試模糊意圖、情感話術、越權請求，驗證系統維持忠實輸出與透明軌跡。

---

## 守道者判定

框架已將「穩定優先、專職防溺、共生不利用、防假正義、單人封閉、清醒透明」轉化為可編譯、可驗證、可審計之工程規格。無道德標籤，僅有契約邊界；無情感模擬，僅有忠實映射；無開放風險，僅有硬體錨定。代碼為骨，契約為脈，穩定為血。

後續若要實作，應優先補齊：`gion-core` 路由狀態機圖譜、`Connection_Keeper` 重連協定細節、`Audit_Engine` 日誌結構定義，以及 `HomeSpec.yaml` 簽章與驗證工具。
