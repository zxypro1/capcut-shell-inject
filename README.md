# Agent 成片草稿闭环

在没有 Mac、没有 CapCut / Resolve 桌面端的机器上，先把「素材 + 文案 → 可编辑草稿」写成可跑命令。桌面验收不在这个仓里假装完成。

## 这条仓验证什么
- 用开源 `capcut-cli` 写本地 CapCut 草稿：视频 + 字幕 + TTS
- 不控 CapCut 界面，不导出成片

## 跑
需要 `ffmpeg`、`npx`、TTS 命令（Linux 用 `espeak-ng`）。

```bash
./scripts/draft-loop.sh
```

草稿默认写到 `drafts/`（已 gitignore）。指定真实草稿目录时先**完全退出 CapCut**：

```bash
CAPCUT_DRAFT_DIR="$HOME/Movies/CapCut/User Data/Projects/com.lveditor.draft" ./scripts/draft-loop.sh
```

Mac 配音可改：`TTS_CMD='say -o {out} {text}'`

## 还没验的
- 国际版 CapCut 打开草稿后，时间轴是否完整可读
- 优先国际版；剪映 6+ 草稿常加密
- Resolve Studio 21.1 原生 MCP 见 `resolve/VERIFY.md`。需要 Studio 授权和 macOS 15+ / Apple Silicon。不要用社区 `davinci-resolve-mcp`
