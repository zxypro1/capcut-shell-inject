#!/usr/bin/env bash
# Inject video + English SRT + VO into an App-created CapCut shell.
# CapCut must be fully quit. Do not use this to create a new draft from scratch.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${PROJECT:-}"
if [[ -z "$PROJECT" ]]; then
  echo "Set PROJECT to an App-created CapCut draft folder." >&2
  exit 1
fi
if [[ ! -d "$PROJECT" ]]; then
  echo "PROJECT not found: $PROJECT" >&2
  exit 1
fi

ASSETS="$ROOT/assets"
VIDEO="${VIDEO:-$ASSETS/sample.mp4}"
SRT="${SRT:-$ASSETS/sample.srt}"
TEXT="${TTS_TEXT:-Hello. Subtitle plus TTS closed loop.}"
VO_WAV="${VO_WAV:-$ASSETS/voiceover.wav}"

command -v ffmpeg >/dev/null || { echo "ffmpeg required" >&2; exit 1; }
command -v npx >/dev/null || { echo "npx required" >&2; exit 1; }

mkdir -p "$ASSETS"

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

if [[ ! -f "$VO_WAV" ]]; then
  if command -v say >/dev/null; then
    AIFF="${VO_WAV%.wav}.aiff"
    say -o "$AIFF" "$TEXT"
    ffmpeg -y -i "$AIFF" -acodec pcm_s16le "$VO_WAV"
  elif command -v espeak-ng >/dev/null; then
    espeak-ng -w "$VO_WAV" "$TEXT"
  else
    echo "Need say (macOS) or espeak-ng for TTS" >&2
    exit 1
  fi
fi

DUR="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$VO_WAV")"
capcut() { npx --yes capcut-cli@0.22.0 "$@"; }

capcut add-video "$PROJECT" "$VIDEO" 0s 5s
capcut import-srt "$PROJECT" "$SRT"
capcut add-audio "$PROJECT" "$VO_WAV" 0s "$DUR"
capcut sync-timelines "$PROJECT" --nested --apply
capcut register "$PROJECT" --materials --apply || true
capcut tracks "$PROJECT" -H
capcut lint "$PROJECT" -H || true

echo "injected: $PROJECT"
echo "reopen CapCut and open this project to verify the timeline"
