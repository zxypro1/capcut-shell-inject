# Troubleshooting

## “This draft comes from an unconventional path”

CapCut 9.x rejects drafts created only on disk (CLI `quickstart`, copied folders, etc.).

**Fix:** create an empty project **inside the CapCut app**, quit CapCut, then run `scripts/inject-shell.sh` against that folder. Do not invent a new draft directory yourself.

## Writes vanish or CapCut overwrites the timeline

CapCut autosaves while open and can discard external edits.

**Fix:** fully quit CapCut (not just close the window) before any inject / `capcut-cli` write. Reopen only after the script finishes.

## Timeline empty after reopen (CapCut 8.7+)

The app may read `draft_info.json`, `template-2.tmp`, or nested `Timelines/<id>/` instead of a root-only edit.

**Fix:** after inject, run:

```bash
npx capcut-cli@0.22.0 sync-timelines "$PROJECT" --nested --apply
npx capcut-cli@0.22.0 register "$PROJECT" --materials --apply
```

`inject-shell.sh` already does this.

## Media shows as missing / relink prompt

Paths outside the draft folder, or missing `draft_materials` registration on CapCut 9.1+.

**Fix:** keep video/audio under `$PROJECT/assets/…` and run `register --materials --apply`.

## `say -o file.wav` fails on macOS

`say` often cannot write WAV directly (`Opening output file failed: fmt?`).

**Fix:** write AIFF then convert (what `inject-shell.sh` does), or use another TTS that emits WAV.

## Linux `draft-loop.sh` draft will not open in CapCut

Expected. That script is CI/smoke only. Desktop acceptance requires the shell-first flow on macOS with international CapCut.
