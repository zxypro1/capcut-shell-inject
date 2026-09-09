# Resolve Studio 21.1 原生 MCP 验证记录

这不是可执行实现。Linux 环境跑不了 Resolve，也不要用社区包 `davinci-resolve-mcp` 冒充原生功能。

## 前提
- Resolve **Studio** 21.1（免费版只有控制台脚本，无外部 MCP）
- 专用空项目。21.1 工程不能降回 20.3，不要打开正式项目
- 入口：`File > Setup AI Assistants`
- 官方客户端：Claude / Claude Code / Codex
- 系统：macOS 15+ / Apple Silicon；进阶 AI 工具约 16GB 显存

## 官方示例（逐条记失败点）
1. Media Pool 放入长片
2. 生成约 3 分钟高光
3. 删除短于 1 秒的剪辑
4. 导出 H.265

| 步骤 | 结果 | 失败点 | 时间 |
| --- | --- | --- | --- |
| 安装/授权 Studio 21.1 | 未跑 | | |
| Setup AI Assistants 接通 | 未跑 | | |
| 长片 → 3min 高光 | 未跑 | | |
| 删除 <1s 剪辑 | 未跑 | | |
| H.265 导出 | 未跑 | | |
