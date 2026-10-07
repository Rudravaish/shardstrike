#!/bin/bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_WORK="${GEMRUSH_BUILD_WORK:-$GAME_ROOT/.build/mac}"
GAME_APP="$GAME_ROOT/Playable/Gem Rush.app"
GAME_SDK="$(xcrun --sdk macosx --show-sdk-path)"
GAME_ARCH="$(uname -m)"

mkdir -p "$GAME_WORK/ModuleCache" "$GAME_APP/Contents/MacOS" "$GAME_APP/Contents/Resources"
xcrun swiftc \
  -parse-as-library \
  -swift-version 5 \
  -sdk "$GAME_SDK" \
  -target "$GAME_ARCH-apple-macosx13.0" \
  -module-cache-path "$GAME_WORK/ModuleCache" \
  -O \
  "$GAME_ROOT"/GemRush/*.swift \
  -framework SwiftUI -framework SceneKit -framework AppKit -framework AVFoundation \
  -o "$GAME_APP/Contents/MacOS/GemRush"

cat > "$GAME_APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key><string>en</string>
  <key>CFBundleDisplayName</key><string>Gem Rush</string>
  <key>CFBundleExecutable</key><string>GemRush</string>
  <key>CFBundleIdentifier</key><string>com.local.gemrush</string>
  <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
  <key>CFBundleName</key><string>Gem Rush</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.7.1</string>
  <key>CFBundleVersion</key><string>8</string>
  <key>LSApplicationCategoryType</key><string>public.app-category.action-games</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSPrincipalClass</key><string>NSApplication</string>
</dict>
</plist>
PLIST

cp "$GAME_ROOT/GemRush/PrivacyInfo.xcprivacy" "$GAME_APP/Contents/Resources/PrivacyInfo.xcprivacy"

codesign --force --sign - "$GAME_APP"
printf 'Built %s\n' "$GAME_APP"
