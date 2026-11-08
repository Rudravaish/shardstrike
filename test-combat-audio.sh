#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
AUDIO_WORK="${GEMRUSH_AUDIO_TEST_WORK:-$GAME_ROOT/.build/combat-audio}"
AUDIO_APP="$AUDIO_WORK/Combat Sound Check.app"
mkdir -p "$AUDIO_WORK/ModuleCache" "$AUDIO_APP/Contents/MacOS"
cat "$GAME_ROOT/GemRush/GameAudio.swift" "$GAME_ROOT/Tests/CombatAudioPlaybackValidation.swift" > "$AUDIO_WORK/GameAudio.swift"
xcrun swiftc -O -parse-as-library -swift-version 5 \
  -module-cache-path "$AUDIO_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$AUDIO_WORK/GameAudio.swift" \
  -framework SwiftUI -framework AppKit -framework AVFoundation \
  -o "$AUDIO_APP/Contents/MacOS/CombatSoundCheck"
cat > "$AUDIO_APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>CombatSoundCheck</string>
<key>CFBundleIdentifier</key><string>com.shardstrike.tests.combataudio</string>
<key>CFBundleName</key><string>Combat Sound Check</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
codesign --force --sign - "$AUDIO_APP"
printf 'Built native playback fixture: %s\n' "$AUDIO_APP"
