# Resolve Studio MCP vs CapCut shell-inject

One-page contrast for README / issue replies. This does **not** bypass a Resolve Studio license.

| | CapCut shell-inject | Resolve Studio 21.1 native MCP |
| --- | --- | --- |
| Cost to try | Free CapCut (intl) + this recipe | Resolve **Studio** license (free Resolve has console scripts only; no external MCP) |
| What you get | Editable CapCut timeline that **opens** on 9.x | Agent-driven edit/export inside Resolve (official example: long clip → ~3min highlight → drop &lt;1s cuts → H.265) |
| Path | App empty shell → quit → inject → reopen | `File > Setup AI Assistants` (Claude / Claude Code / Codex) |
| Blocks we hit | CapCut 9.x “unconventional path” on external new drafts | Needs Studio auth; macOS 15+ / Apple Silicon for the official client path |
| Do not | Create drafts only on disk; Computer Use as the main path | Use community `davinci-resolve-mcp` as a substitute for native Studio MCP |

## When to cite which

- Agent writes CapCut drafts that **won’t open** on 9.x → shell-inject (this repo).
- Need Resolve-grade timeline AI + official MCP render loop **and** you already have Studio → Resolve native MCP.
- Do **not** frame shell-inject as a crack for Studio. Different product, different gate.

## Nail sentences

- CapCut: `Shell-first inject so CapCut 9.x actually opens agent-written drafts.`
- Resolve: `Studio MCP can render; CapCut shell-inject is the free path to an openable draft — not a Studio workaround.`
