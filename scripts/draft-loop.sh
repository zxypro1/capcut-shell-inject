#!/usr/bin/env bash
# Footage + script -> CapCut draft (video + TTS + SRT). Does not open CapCut.
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

capcut tts "$PROJECT" 0s \
  --text "$TEXT" \
  --tts-cmd "$TTS_CMD"

capcut lint "$PROJECT"
capcut info "$PROJECT" -H || true

echo "draft: $PROJECT"
echo "not verified in CapCut app. quit CapCut before copying into the intl draft dir."
