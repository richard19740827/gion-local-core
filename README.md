# 愛馬仕網路使用者介面

[Hermes Agent]（https://hermes-agent.nousresearch.com/）是一個複雜的自主代理，它存在於您的伺服器上，透過終端或訊息傳遞應用程式訪問，它記住它所學的內容，並且越跑越久，能力越強。

Hermes WebUI是瀏覽器中一個輕量級的黑暗主題網路應用程式介面[Hermes Agent](https://hermes-agent.nousresearch.com/)。

與CLI體驗完全平等——您可以在終端上完成的一切，

你可以透過這個使用者介面完成。 沒有構建步驟，沒有框架，沒有捆綁器。 只是蟒蛇

和香草JS。

佈局：三面板。 會話和導航的左側欄，聊天中心，

適合工作區檔案瀏覽。 模型、配置檔案和工作區控制在

**作曲家頁尾** — 總是作曲時可見。 迴圈上下文環

一目瞭然地顯示令牌的使用情況。 所有設定和會話工具都在

**愛馬仕控制中心**（側邊欄底部的發射器）。

## 數位蓮花：訊息閘道快速入口

如果 Hermes WebUI 已經能在瀏覽器打開，但 Telegram / Discord / Slack 仍像「隱藏的開關」一樣沒有回應，請先看中文的 [數位蓮花訊息閘道流程](docs/troubleshooting.md#數位蓮花訊息閘道打不開)。它會帶你確認正在使用的 `HERMES_HOME` / `HERMES_CONFIG_PATH`、避免把 Bot token 放進截圖或 git、重新啟動 gateway，並用 `/api/gateway/status` 確認通道是否活著。

English operators can use the [messaging gateway quickstart](docs/troubleshooting.md#messaging-gateway-channel-not-opening).

<img width="2448" height="1748" alt="Hermes Web UI — 三面板佈局" src="https://github.com/user-attachments/assets/6bf8af4c-209d-441e-8b92-6515d7a0c369" />

<表格>

<tr>

<td width="50%" 對齊="中心">

<img width="2940" height="1848" alt="具有完整配置檔案支援的輕模式" src="https://github.com/user-attachments/assets/4ef3a59c-7a66-4705-b4e7-cb9148fe4c47" />
