#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_TEST_WORK="$(mktemp -d "${TMPDIR:-/tmp}/gemrush-controller.XXXXXX")"
trap 'rm -rf "$GAME_TEST_WORK"' EXIT
# Compile an isolated copy so tests can inspect SceneKit encounter state without
# exposing debug controls in the app or reading/writing the player's save.
sed 's/UserDefaults.standard/ValidationStore.defaults/g' "$GAME_ROOT/GemRush/GameController.swift" > "$GAME_TEST_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/ControllerValidation.swift" >> "$GAME_TEST_WORK/GameController.swift"
xcrun swiftc -parse-as-library -swift-version 5 \
  -module-cache-path "$GAME_TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$GAME_ROOT/GemRush/HeroCombat.swift" \
  "$GAME_ROOT/GemRush/GameRules.swift" "$GAME_ROOT/GemRush/PlayerProfile.swift" \
  "$GAME_ROOT/GemRush/Aiming.swift" "$GAME_ROOT/GemRush/BossPatterns.swift" \
  "$GAME_ROOT/GemRush/ArenaEnvironment.swift" "$GAME_ROOT/GemRush/ArenaArt.swift" \
  "$GAME_ROOT/GemRush/SceneArt.swift" "$GAME_TEST_WORK/GameController.swift" \
  -framework SwiftUI -framework SceneKit -framework AppKit \
  -o "$GAME_TEST_WORK/ControllerValidation"
"$GAME_TEST_WORK/ControllerValidation"
