#!/usr/bin/env bash
# Linux/CI smoke: synthetic draft under drafts/. Not accepted by CapCut 9.3.
# For a CapCut-openable project, create an empty project in the CapCut app,
# quit CapCut, then run scripts/inject-shell.sh with PROJECT=...
set -euo pipefail

NAME="${1:-opp2-subtitle-tts}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DRAFTS="${CAPCUT_DRAFT_DIR:-$ROOT/drafts}"
ASSETS="$ROOT/assets"
VIDEO="${VIDEO:-$ASSETS/sample.mp4}"
SRT="${SRT:-$ASSETS/sample.srt}"
TEXT="${TTS_TEXT:-Hello. Subtitle plus TTS closed loop.}"
TTS_CMD="${TTS_CMD:-espeak-ng -w {out} {text}}"

command -v ffmpeg >/dev/null || { echo "ffmpeg required" >&2; exit 1; }
command -v npx >/dev/null || { echo "npx required" >&2; exit 1; }

mkdir -p "$ASSETS" "$DRAFTS"

if [[ ! -f "$VIDEO" ]]; then
  ffmpeg -y -f lavfi -i "color=c=0x1a1a1a:s=1080x1920:d=5:r=30" \
    -f lavfi -i "sine=frequency=440:duration=5" \
    -shortest -c:v libx264 -pix_fmt yuv420p -c:a aac "$VIDEO"
fi

if [[ ! -f "$SRT" ]]; then
  cat > "$SRT" << 'SRT'
1
00:00:00,000 --> 00:00:02,200
Subtitle plus TTS

2
00:00:02,200 --> 00:00:04,800
closed loop
SRT
fi

capcut() { npx --yes capcut-cli@0.22.0 "$@"; }

capcut quickstart "$NAME" \
  --video "$VIDEO" \
  --srt "$SRT" \
  --drafts "$DRAFTS" \
  --ratio 9:16

PROJECT="$DRAFTS/$NAME"

if command -v espeak-ng >/dev/null; then
  capcut tts "$PROJECT" 0s --text "$TEXT" --tts-cmd "$TTS_CMD" || true
fi

capcut lint "$PROJECT" || true
capcut info "$PROJECT" -H || true

echo "draft: $PROJECT"
echo "smoke only — CapCut 9.3 rejects external new drafts. Use inject-shell.sh on an App-created shell."
