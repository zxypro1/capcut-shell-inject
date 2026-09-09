# CapCut draft loop

Write an editable CapCut draft from footage plus a script, without a Mac and without the CapCut or Resolve desktop apps. This repo does not claim the desktop apps have accepted the draft.

## What this checks
- Use open-source `capcut-cli` to write a local CapCut draft: video + subtitles + TTS
- Do not drive the CapCut UI, and do not export a finished file

## Run
Requires `ffmpeg`, `npx`, and a TTS command (`espeak-ng` on Linux).

```bash
./scripts/draft-loop.sh
```

Drafts land in `drafts/` (gitignored). To write into a real CapCut draft folder, quit CapCut completely first:

```bash
CAPCUT_DRAFT_DIR="$HOME/Movies/CapCut/User Data/Projects/com.lveditor.draft" ./scripts/draft-loop.sh
```

On macOS, override TTS with `TTS_CMD='say -o {out} {text}'`.

## Not verified yet
- Whether international CapCut opens the draft with a fully readable timeline
- Prefer international CapCut. Jianying 6+ drafts are often encrypted
- Resolve Studio 21.1 native MCP notes are in `resolve/VERIFY.md`. That path needs a Studio license and macOS 15+ / Apple Silicon. Do not use the community package `davinci-resolve-mcp`
