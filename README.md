# CapCut shell inject

**Problem:** CapCut 9.x rejects drafts created outside the app (“This draft comes from an unconventional path and cannot be used”). Agent and script pipelines that write JSON on disk often cannot open the project.

**Who it’s for:** developers wiring Agent / automated video workflows, and small teams that need footage + script to land as an **editable** CapCut timeline—not a locked MP4.

**Value:** the last mile that actually opens—**App-created empty shell → quit → inject video / English subtitles / VO → reopen**. Verified on international CapCut **9.3.0** (macOS) with shell `shell-opp2`.

## One-liner

> Shell-first inject so CapCut 9.x actually opens agent-written drafts.

Not another CapCut MCP. Use it as the **step before** CapCut MCP / `capcut-cli` when 9.x refuses external drafts with “unconventional path”: **App shell → quit → inject → reopen**.

## vs CapCut MCP / plain `capcut-cli`

| | CapCut in-app / random MCP wrappers | `capcut-cli` alone | This repo |
| --- | --- | --- | --- |
| Create a new draft from disk | Often hits “unconventional path” on 9.3 | `quickstart` hits the same wall | **Does not create shells** — you create the shell in the app |
| Edit an existing draft | Varies; many ignore 9.x mirrors | Strong JSON edits | Thin wrapper: inject + sync + register |
| CapCut 8.7+ mirrors | Easy to miss `template-2.tmp` / nested `Timelines/` | Has `sync-timelines --nested` | Calls that after every inject |
| Computer Use / UI automation | Common fragile path | Not required | Explicitly out of scope |
| What we ship | — | General CLI | **Verified shell-first recipe** + `inject-shell.sh` |

We depend on [`capcut-cli`](https://github.com/renezander030/capcut-cli). The product is the **accepted workflow**, not a fork of the CLI.

## Demo (optional)

A contrast recording helps (see `docs/DEMO.md`): flash “unconventional path” on an external draft, then open `shell-opp2` and scrub the three tracks. Not required to use the script; add `docs/demo.mp4` when you have one.

## Verified flow

1. In CapCut, create an **empty project** (official shell).
2. Quit CapCut completely.
3. Inject into that shell:

```bash
PROJECT="$HOME/Movies/CapCut/User Data/Projects/com.lveditor.draft/YOUR_SHELL" \
  ./scripts/inject-shell.sh
```

4. Keep the shell `platform` / `app_source` / path identity. Media lands under the draft `assets/`.
5. Script runs `sync-timelines --nested --apply` and `register --materials --apply`.
6. Reopen CapCut and open the same project.

Pass criteria:

- Opens without “unconventional path”
- Timeline has ~5s video, 2 English subtitle cues, ~3.2s voiceover
- Media is readable (not missing)

## Why shell-first

| Approach | Result on CapCut 9.3 |
| --- | --- |
| CLI `quickstart` / external new draft | Rejected: unconventional path |
| App-created empty shell + inject | Opens; timeline editable |

On CapCut 8.7+, the app often reads `draft_info.json` / `template-2.tmp`, not a synthetic `draft_content.json`.

## Inject details

Requires `ffmpeg`, `npx`, and TTS (`say` on macOS or `espeak-ng` on Linux). CapCut must be **fully quit** before writing.

Optional env: `VIDEO`, `SRT`, `TTS_TEXT`, `VO_WAV`.

macOS: `say` writing `.wav` often fails; the script uses AIFF then converts to WAV.

## Linux smoke only

`./scripts/draft-loop.sh` builds a synthetic draft under `drafts/` for CI. CapCut 9.3 will **not** accept that draft. Desktop acceptance requires shell-first inject.

## Out of scope

- Driving the CapCut UI (Computer Use)
- Final export from CapCut
- Resolve Studio MCP — see `resolve/VERIFY.md`

## Troubleshooting

See [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) for unconventional path, quit-before-write, 9.x mirrors, and missing media.

## Tooling

- [`capcut-cli`](https://github.com/renezander030/capcut-cli) for edits
- Prefer international CapCut. Jianying 6+ drafts are often encrypted.
