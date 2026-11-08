#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
# Point at a read-only source snapshot to compare the same workload before/after.
GAME_PERF_SOURCE="${GAME_PERF_SOURCE:-$GAME_ROOT/GemRush}"
GAME_PERF_WORK="$(mktemp -d "${TMPDIR:-/tmp}/gemrush-performance.XXXXXX")"
trap 'rm -rf "$GAME_PERF_WORK"' EXIT
sed -e 's/storeEnabled: Bool = true/storeEnabled: Bool = false/' -e 's/UserDefaults.standard/ValidationStore.defaults/g' "$GAME_PERF_SOURCE/GameController.swift" > "$GAME_PERF_WORK/GameController.swift"
cat "$GAME_ROOT/Tests/PerformanceValidation.swift" >> "$GAME_PERF_WORK/GameController.swift"
GAME_AUDIO_SOURCE=("$GAME_PERF_SOURCE/SceneArt.swift")
GAME_PERF_FLAGS=(-O -parse-as-library -swift-version 5)
if [[ -f "$GAME_PERF_SOURCE/GameAudio.swift" ]]; then
  GAME_AUDIO_SOURCE+=("$GAME_PERF_SOURCE/GameAudio.swift")
fi
if rg -q 'init\(allowsDeviceAudio:' "$GAME_PERF_SOURCE/GameController.swift"; then
  GAME_PERF_FLAGS+=(-D PERFORMANCE_SILENT_AUDIO)
fi
if rg -q 'func advanceFrame\(realDT:' "$GAME_PERF_SOURCE/GameController.swift"; then
  GAME_PERF_FLAGS+=(-D PERFORMANCE_FIXED_STEP)
fi
xcrun swiftc "${GAME_PERF_FLAGS[@]}" \
  -module-cache-path "$GAME_PERF_WORK/ModuleCache" \
  "$GAME_PERF_SOURCE/Hero.swift" "$GAME_PERF_SOURCE/HeroCombat.swift" \
  "$GAME_PERF_SOURCE/GemStore.swift" "$GAME_PERF_SOURCE/PurchaseLedger.swift" \
  "$GAME_PERF_SOURCE/GameRules.swift" "$GAME_PERF_SOURCE/PlayerProfile.swift" \
  "$GAME_PERF_SOURCE/Aiming.swift" "$GAME_PERF_SOURCE/BossPatterns.swift" \
  "$GAME_PERF_SOURCE/ArenaEnvironment.swift" "$GAME_PERF_SOURCE/ArenaArt.swift" \
  "${GAME_AUDIO_SOURCE[@]}" "$GAME_PERF_WORK/GameController.swift" \
  -framework SwiftUI -framework SceneKit -framework AppKit -framework AVFoundation \
  -o "$GAME_PERF_WORK/PerformanceValidation"
GEMRUSH_DISABLE_AUDIO=1 "$GAME_PERF_WORK/PerformanceValidation"
