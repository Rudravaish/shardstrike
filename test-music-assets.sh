#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
MUSIC_WORK="$(mktemp -d "${TMPDIR:-/tmp}/shardstrike-music.XXXXXX")"
trap 'rm -rf "$MUSIC_WORK"' EXIT
xcrun swiftc -O -parse-as-library -swift-version 5 -module-cache-path "$MUSIC_WORK/ModuleCache" \
  "$GAME_ROOT/Tests/MenuMusicAssetTests.swift" -framework AVFoundation -o "$MUSIC_WORK/MusicAssetTests"
MUSIC_USE_FALLBACK=0
for MUSIC_INDEX in $(seq 0 16); do
  if [[ "$MUSIC_INDEX" == 0 ]]; then
    MUSIC_NAME=MenuTheme; MUSIC_DURATION=48
  elif [[ "$MUSIC_INDEX" == 1 ]]; then
    MUSIC_NAME=CollectionTheme; MUSIC_DURATION=15
  else
    MUSIC_LEVEL=$((MUSIC_INDEX - 1))
    MUSIC_NAME=$(printf 'Battle%02d' "$MUSIC_LEVEL")
    MUSIC_BPM=$((112 + (MUSIC_LEVEL - 1) * 4))
    MUSIC_DURATION=$(awk "BEGIN { printf \"%.9f\", 5760 / $MUSIC_BPM }")
  fi
  MUSIC_ASSET="$GAME_ROOT/GemRush/Resources/$MUSIC_NAME.m4a"
  echo "Checking $MUSIC_NAME"
  if [[ "$MUSIC_USE_FALLBACK" == 0 ]]; then
    if "$MUSIC_WORK/MusicAssetTests" "$MUSIC_ASSET" - "$MUSIC_DURATION"; then continue; else
      MUSIC_STATUS=$?
      if [[ "$MUSIC_STATUS" != 77 ]]; then exit "$MUSIC_STATUS"; fi
      MUSIC_USE_FALLBACK=1
    fi
  fi
  # Sandboxed shells may not discover Apple's AAC component. The independent
  # decoder validates the shipped asset; the native app fixture checks playback.
  if ! command -v ffmpeg >/dev/null; then
    echo 'Music validation needs Apple AAC support or FFmpeg in this environment.'
    exit 77
  fi
  ffmpeg -hide_banner -loglevel error -y -i "$MUSIC_ASSET" -t "$MUSIC_DURATION" \
    -c:a pcm_f32le "$MUSIC_WORK/Decoded.wav"
  "$MUSIC_WORK/MusicAssetTests" "$MUSIC_ASSET" "$MUSIC_WORK/Decoded.wav" "$MUSIC_DURATION"
done
printf 'All 17 soundtrack assets passed (170 checks).\n'
