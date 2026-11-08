#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_TEST_WORK="$(mktemp -d "${TMPDIR:-/tmp}/shardstrike-storekit.XXXXXX")"
trap 'rm -rf "$GAME_TEST_WORK"' EXIT
GAME_TEST_APP="$GAME_TEST_WORK/StoreKitIntegration.app"
GAME_TEST_FRAMEWORKS="$(xcode-select -p)/Platforms/MacOSX.platform/Developer/Library/Frameworks"
mkdir -p "$GAME_TEST_APP/Contents/MacOS" "$GAME_TEST_APP/Contents/Resources" "$GAME_TEST_WORK/ModuleCache"
cp "$GAME_ROOT/StoreTesting.storekit" "$GAME_TEST_APP/Contents/Resources/StoreTesting.storekit"
cat > "$GAME_TEST_APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>com.shardstrike.storekit.integration</string>
<key>CFBundleName</key><string>Shardstrike Store Tests</string>
<key>CFBundleExecutable</key><string>StoreKitIntegration</string>
<key>CFBundleVersion</key><string>1</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>LSUIElement</key><true/>
</dict></plist>
PLIST
xcrun swiftc -parse-as-library -swift-version 5 \
  -target "$(uname -m)-apple-macosx14.0" \
  -module-cache-path "$GAME_TEST_WORK/ModuleCache" \
  -F "$GAME_TEST_FRAMEWORKS" -Xlinker -rpath -Xlinker "$GAME_TEST_FRAMEWORKS" \
  "$GAME_ROOT/GemRush/Hero.swift" "$GAME_ROOT/GemRush/PurchaseLedger.swift" \
  "$GAME_ROOT/GemRush/GemStore.swift" "$GAME_ROOT/Tests/StoreKitIntegrationTests.swift" \
  -framework StoreKit -framework StoreKitTest \
  -o "$GAME_TEST_APP/Contents/MacOS/StoreKitIntegration"
codesign --force --sign - "$GAME_TEST_APP"
SHARDSTRIKE_STORE_TESTING=1 "$GAME_TEST_APP/Contents/MacOS/StoreKitIntegration"
