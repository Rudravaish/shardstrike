#!/bin/bash
set -euo pipefail

GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
TEST_WORK="$(mktemp -d "${TMPDIR:-/tmp}/gemrush-rules.XXXXXX")"
trap 'rm -rf "$TEST_WORK"' EXIT

# Tests compile the production rules directly; they do not launch the game or
# touch its saved campaign. Compilation artifacts stay in a temporary folder.
xcrun swiftc \
  -parse-as-library \
  -swift-version 5 \
  -module-cache-path "$TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" \
  "$GAME_ROOT/GemRush/GameRules.swift" \
  "$GAME_ROOT/GemRush/Aiming.swift" \
  "$GAME_ROOT/Tests/GameRulesTests.swift" \
  -o "$TEST_WORK/GameRulesTests"

"$TEST_WORK/GameRulesTests"

xcrun swiftc \
  -parse-as-library \
  -swift-version 5 \
  -module-cache-path "$TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/BossPatterns.swift" \
  "$GAME_ROOT/Tests/BossPatternsTests.swift" \
  -o "$TEST_WORK/BossPatternsTests"

"$TEST_WORK/BossPatternsTests"


xcrun swiftc -parse-as-library -swift-version 5 -module-cache-path "$TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$GAME_ROOT/GemRush/GameRules.swift" \
  "$GAME_ROOT/GemRush/PlayerProfile.swift" "$GAME_ROOT/GemRush/HeroCombat.swift" \
  "$GAME_ROOT/Tests/PlayerProfileTests.swift" -o "$TEST_WORK/PlayerProfileTests"
"$TEST_WORK/PlayerProfileTests"

xcrun swiftc -parse-as-library -swift-version 5 -module-cache-path "$TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$GAME_ROOT/GemRush/HeroCombat.swift" \
  "$GAME_ROOT/Tests/HeroCombatTests.swift" -o "$TEST_WORK/HeroCombatTests"
"$TEST_WORK/HeroCombatTests"

xcrun swiftc -parse-as-library -swift-version 5 -module-cache-path "$TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Aiming.swift" "$GAME_ROOT/GemRush/ArenaEnvironment.swift" \
  "$GAME_ROOT/Tests/ArenaEnvironmentTests.swift" -o "$TEST_WORK/ArenaEnvironmentTests"
"$TEST_WORK/ArenaEnvironmentTests"
