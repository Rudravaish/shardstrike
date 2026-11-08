#!/bin/bash
set -euo pipefail
GAME_ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_TEST_WORK="$(mktemp -d "${TMPDIR:-/tmp}/shardstrike-paid-ledger.XXXXXX")"
trap 'rm -rf "$GAME_TEST_WORK"' EXIT
xcrun swiftc -parse-as-library -swift-version 5 \
  -module-cache-path "$GAME_TEST_WORK/ModuleCache" \
  "$GAME_ROOT/GemRush/Hero.swift" "$GAME_ROOT/GemRush/PurchaseLedger.swift" \
  "$GAME_ROOT/Tests/PurchaseLedgerTests.swift" -o "$GAME_TEST_WORK/PurchaseLedgerTests"
"$GAME_TEST_WORK/PurchaseLedgerTests"
