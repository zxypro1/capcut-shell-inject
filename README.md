# CapCut draft loop

Turn footage plus a script into an editable CapCut timeline: video, English subtitles, and a short voiceover.

## Verified delivery shape (CapCut 9.3, macOS)

**Do not create a draft from outside CapCut.** CapCut 9.3 rejects CLI-created projects with:

> This draft comes from an unconventional path and cannot be used.

The path that works:

1. In the CapCut app, create an **empty project** (the official shell).
2. Quit CapCut completely.
3. Inject media into that shell with `capcut-cli` (or the script below).
4. Keep the shell `platform` / `app_source` / path identity. Put media under the draft folder.
5. Sync timeline mirrors (`draft_info.json`, `template-2.tmp`, nested `Timelines/`).
6. Reopen CapCut and open the same project.

Pass criteria we verified on international CapCut 9.3.0 with shell `shell-opp2`:

- Project opens without the unconventional-path error
- Timeline has ~5s video, 2 English subtitle cues, ~3.2s voiceover
- Media is readable (not marked missing)

## Why shell-first

| Approach | Result on CapCut 9.3 |
| --- | --- |
| CLI `quickstart` / external new draft | Rejected: unconventional path |
| App-created empty shell + inject | Opens; timeline editable |

On CapCut 8.7+, the app often reads `draft_info.json` / `template-2.tmp`, not a synthetic `draft_content.json`. Prefer writing through those mirrors and running `capcut sync-timelines <project> --nested --apply`.

## Inject into an existing shell

Requires `ffmpeg`, `npx`, and a TTS command. On macOS, CapCut must be **fully quit** before writing.

```bash
# PROJECT = path to the App-created draft folder
PROJECT="$HOME/Movies/CapCut/User Data/Projects/com.lveditor.draft/shell-opp2" \
  ./scripts/inject-shell.sh
```

Optional env vars: `VIDEO`, `SRT`, `TTS_TEXT`, `TTS_CMD`.

macOS voiceover default uses `say` via AIFF then converts to WAV (direct `say -o *.wav` often fails).

```bash
TTS_CMD='say -o {out} {text}'   # may fail for .wav; the script handles AIFF→WAV
```

What the script does:

1. Ensures sample video / SRT / voiceover assets
2. `capcut add-video` / `import-srt` / `add-audio` into `$PROJECT`
3. `capcut sync-timelines "$PROJECT" --nested --apply`
4. `capcut register "$PROJECT" --materials --apply`
5. Prints track summary

## Linux smoke only

`./scripts/draft-loop.sh` still builds a synthetic draft under `drafts/` for CI/smoke. That path is **not** CapCut-accepted on 9.3. Use it only to exercise commands; desktop acceptance requires the shell-first flow above.

## Out of scope

- Driving the CapCut UI (Computer Use)
- Final export from CapCut
- Resolve Studio 21.1 native MCP — see `resolve/VERIFY.md` (needs a Studio license; do not use community `davinci-resolve-mcp`)

## Tooling

- [`capcut-cli`](https://github.com/renezander030/capcut-cli) for draft edits
- Prefer international CapCut. Jianying 6+ drafts are often encrypted.
