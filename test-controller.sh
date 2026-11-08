#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_TEST_WORK="$(mktemp -d "${TMPDIR:-/tmp}/gemrush-controller.XXXXXX")"
trap 'rm -rf "$GAME_TEST_WORK"' EXIT
# Compile an isolated copy so tests can inspect SceneKit encounter state without
# exposing debug controls in the app or reading/writing the player's save.
sed -e 's/storeEnabled: Bool = true/storeEnabled: Bool = false/' \
  -e 's/UserDefaults.standard/ValidationStore.defaults/g' \
  -e 's/init(allowsDeviceAudio: Bool = true/init(allowsDeviceAudio: Bool = false/' \
  -e 's/audio.playHeroEffort(hero: rules.hero)/ValidationAudioEvents.effort(rules.hero); audio.playHeroEffort(hero: rules.hero)/g' \
  -e 's/audio.playEnemyShot(level: rules.levelNumber)/ValidationAudioEvents.shot(rules.levelNumber); audio.playEnemyShot(level: rules.levelNumber)/g' \
  -e 's/audio.playEnemyHeavy(level: rules.levelNumber)/ValidationAudioEvents.heavy(rules.levelNumber); audio.playEnemyHeavy(level: rules.levelNumber)/g' \
  "$GAME_ROOT/GemRush/GameController.swift" > "$GAME_TEST_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/ControllerValidation.swift" >> "$GAME_TEST_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/TutorialValidation.swift" >> "$GAME_TEST_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/FrameTimingValidation.swift" >> "$GAME_TEST_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/BossPresentationValidation.swift" >> "$GAME_TEST_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/PaidStoreValidation.swift" >> "$GAME_TEST_WORK/GameController.swift"
xcrun swiftc -parse-as-library -swift-version 5 \
  -module-cache-path "$GAME_TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$GAME_ROOT/GemRush/HeroCombat.swift" \
  "$GAME_ROOT/GemRush/GameAudio.swift" \
  "$GAME_ROOT/GemRush/GemStore.swift" "$GAME_ROOT/GemRush/PurchaseLedger.swift" \
  "$GAME_ROOT/GemRush/GameRules.swift" "$GAME_ROOT/GemRush/PlayerProfile.swift" \
  "$GAME_ROOT/GemRush/Aiming.swift" "$GAME_ROOT/GemRush/BossPatterns.swift" \
  "$GAME_ROOT/GemRush/ArenaEnvironment.swift" "$GAME_ROOT/GemRush/ArenaArt.swift" \
  "$GAME_ROOT/GemRush/SceneArt.swift" "$GAME_TEST_WORK/GameController.swift" \
  -framework SwiftUI -framework SceneKit -framework AppKit -framework AVFoundation \
  -o "$GAME_TEST_WORK/ControllerValidation"
"$GAME_TEST_WORK/ControllerValidation"
