# CapCut shell inject

**Problem:** CapCut 9.x rejects drafts created outside the app (“This draft comes from an unconventional path and cannot be used”). Agent and script pipelines that write JSON on disk often cannot open the project.

**Who it’s for:** developers wiring Agent / automated video workflows, and small teams that need footage + script to land as an **editable** CapCut timeline—not a locked MP4.

**Value:** the last mile that actually opens—**App-created empty shell → quit → inject video / English subtitles / VO → reopen**. Verified on international CapCut **9.3.0** (macOS) with shell `shell-opp2`.

> Shell-first inject so CapCut 9.x actually opens agent-written drafts.

Not another CapCut MCP. Use it as the **step before** CapCut MCP / `capcut-cli` when 9.x refuses external drafts.

## How to use

### Requirements

- macOS with **international CapCut** (prefer 9.x; Jianying 6+ drafts are often encrypted)
- `git`, `ffmpeg`, `npx` (Node.js)
- TTS: macOS `say` (default) or `espeak-ng`

### Steps

1. **Create an empty project in CapCut** (File → New). Name it anything, e.g. `shell-opp2`.  
   Do **not** create the draft folder yourself on disk.

2. **Quit CapCut completely** (Cmd+Q). Autosave will overwrite external writes if the app is still running.

3. **Clone and run inject** against that shell folder:

```bash
git clone https://github.com/zxypro1/capcut-shell-inject.git
cd capcut-shell-inject

# Default CapCut draft store on macOS:
# ~/Movies/CapCut/User Data/Projects/com.lveditor.draft/<project-name>

PROJECT="$HOME/Movies/CapCut/User Data/Projects/com.lveditor.draft/shell-opp2" \
  ./scripts/inject-shell.sh
```

4. **Reopen CapCut** and open the same project.

### What you should see

- Project opens (no “unconventional path” dialog)
- Timeline: ~5s video, 2 English subtitle cues, ~3.2s voiceover
- Media readable (not missing / no forced relink)

### Use your own media

```bash
PROJECT="$HOME/Movies/CapCut/User Data/Projects/com.lveditor.draft/YOUR_SHELL" \
VIDEO="/path/to/clip.mp4" \
SRT="/path/to/captions.srt" \
VO_WAV="/path/to/voiceover.wav" \
  ./scripts/inject-shell.sh
```

Optional: `TTS_TEXT="Your line here"` if you omit `VO_WAV` and want the script to synthesize speech.

### What the script does

1. Ensures sample video / SRT / voiceover if you did not pass paths  
2. `capcut add-video` / `import-srt` / `add-audio` into `$PROJECT`  
3. `capcut sync-timelines "$PROJECT" --nested --apply` (CapCut 8.7+ mirrors)  
4. `capcut register "$PROJECT" --materials --apply`  
5. Prints track summary  

Media is copied under `$PROJECT/assets/`. The shell’s `platform` / `app_source` identity is kept.

## Why shell-first

| Approach | Result on CapCut 9.3 |
| --- | --- |
| CLI `quickstart` / external new draft | Rejected: unconventional path |
| App-created empty shell + inject | Opens; timeline editable |

## vs CapCut MCP / plain `capcut-cli`

| | CapCut MCP wrappers | `capcut-cli` alone | This repo |
| --- | --- | --- | --- |
| Create a new draft from disk | Often hits unconventional path | Same wall via `quickstart` | **Does not create shells** — you create the shell in the app |
| Edit an existing draft | Varies | Strong JSON edits | Inject + sync + register |
| CapCut 8.7+ mirrors | Easy to miss | Has `sync-timelines --nested` | Called after every inject |
| What we ship | — | General CLI | Verified shell-first recipe |

Depends on [`capcut-cli`](https://github.com/renezander030/capcut-cli).

## Linux smoke only

`./scripts/draft-loop.sh` builds a synthetic draft under `drafts/` for CI. CapCut 9.3 will **not** accept that draft. Desktop use requires the **How to use** flow above.

## Resolve Studio MCP vs this repo

See [`docs/RESOLVE_VS_CAPCUT.md`](docs/RESOLVE_VS_CAPCUT.md). Not a Studio license bypass.

## Out of scope

- Driving the CapCut UI (Computer Use)
- Final export from CapCut
- Resolve Studio MCP — see `resolve/VERIFY.md`

## Troubleshooting

See [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md).

## Demo (optional)

See [`docs/DEMO.md`](docs/DEMO.md).
