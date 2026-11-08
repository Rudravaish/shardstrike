#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
MUSIC_WORK="${GEMRUSH_MUSIC_TEST_WORK:-$GAME_ROOT/.build/music-playback}"
MUSIC_APP="$MUSIC_WORK/Menu Music Playback Check.app"
mkdir -p "$MUSIC_WORK/ModuleCache" "$MUSIC_APP/Contents/MacOS" "$MUSIC_APP/Contents/Resources"
cat "$GAME_ROOT/GemRush/GameAudio.swift" "$GAME_ROOT/Tests/MenuMusicPlaybackValidation.swift" > "$MUSIC_WORK/GameAudio.swift"
xcrun swiftc -O -parse-as-library -swift-version 5 \
  -module-cache-path "$MUSIC_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$MUSIC_WORK/GameAudio.swift" \
  -framework SwiftUI -framework AppKit -framework AVFoundation \
  -o "$MUSIC_APP/Contents/MacOS/MusicPlaybackCheck"
cat > "$MUSIC_APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>MusicPlaybackCheck</string>
<key>CFBundleIdentifier</key><string>com.shardstrike.tests.menumusic</string>
<key>CFBundleName</key><string>Menu Music Playback Check</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
cp "$GAME_ROOT/GemRush/Resources/"*.m4a "$MUSIC_APP/Contents/Resources/"
codesign --force --sign - "$MUSIC_APP"
printf 'Built native playback fixture: %s\nOpen it to verify actual device playback. It never accesses campaign saves.\n' "$MUSIC_APP"
