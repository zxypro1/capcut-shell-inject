# Resolve Studio 21.1 native MCP verification log

This is not an implementation. This environment cannot run Resolve. Do not substitute the community package `davinci-resolve-mcp` for the native feature.

## Prerequisites
- Resolve **Studio** 21.1 (the free edition has console scripts only, no external MCP)
- A dedicated empty project. A 21.1 project cannot be opened in 20.3. Do not open a real project
- Entry: `File > Setup AI Assistants`
- Official clients: Claude / Claude Code / Codex
- System: macOS 15+ / Apple Silicon. Advanced AI tools need about 16GB of VRAM

## Official example (log each failure)
1. Put a long clip in the Media Pool
2. Generate an about-3-minute highlight
3. Delete cuts shorter than 1 second
4. Export H.265

| Step | Result | Failure | Time |
| --- | --- | --- | --- |
| Install / license Studio 21.1 | not run | | |
| Connect Setup AI Assistants | not run | | |
| Long clip to 3min highlight | not run | | |
| Delete cuts under 1s | not run | | |
| H.265 export | not run | | |
