# Shardstrike verification summary

**Version 0.12.7 / build 23 — verified October 29, 2026.** This is a public summary of the local QA evidence, excluding player saves and account-specific information.

## Automated results

| Suite | Passing assertions |
| --- | ---: |
| Rules, models, audio samples and music assets | 3,846 |
| Controller integration | 2,103 |
| Purchase ledger | 97 |
| **Total** | **6,046** |

Additional native fixtures passed 48 combat-audio and 152 soundtrack playback assertions. These are assertion counts, not independent full playthroughs. Coverage includes sequential unlocks, replay farming prevention, independent hero upgrades, migration, reset behavior, boss patterns, swept collision, tutorials, input clearing, audio routing and purchase delivery recovery.

The optimized stress workload passed 180,000 measured simulation ticks across all 75 hero/boss combinations. Controller CPU timing was median 0.0399 ms, p95 0.1500 ms, maximum 1.9949 ms. Peak counts were 21 projectiles, 24 impacts and 522 scene nodes. These figures exclude GPU rendering and use disabled device audio; they are not an iPhone frame-rate guarantee.

Mac and generic unsigned iPhone Release builds succeeded. All 17 music files matched byte-for-byte across source and built bundles. Save-preservation checks passed.

## Fixes in this pass

- Starting a first campaign honors an already-owned, selected hero; an explicit new campaign still selects Scout.
- Switching hub tabs resets the scroll position to the new page's heading.
- Mixed earned/bought hero purchases reject a stale earned-gem balance rather than spending it twice or silently charging extra bought gems.
- All battle tracks use a continuous percussion arrangement without the slow background layer; hero efforts have deeper registers.
- Boss health increases gradually from 1,100 to 13,600. Attack timing, damage, armor, hero weapon stats and the economy are unchanged.

## Remaining findings

**Rendering:** the native Mac driver exercised all fifteen arenas with production rendering and music, automated movement/aim/fire/dodge, health refills and forced boss phases. Most frames were near 16.7 ms. Repeated tests still showed isolated frames around 200 ms in sector 2 and 190 ms in sector 9. Their cause is not established. The driver is not a natural-victory or human difficulty test.

**Balance:** idealized full-gear, all-hits-land final-boss fights with powers take roughly 18–24 seconds across heroes, versus 8–13 seconds before the rebalance. Completely unupgraded heroes at the final boss take roughly 7–11 minutes in the same model. Hero catch-up and late unlock viability remain design work. Existing in-progress fights retain saved remaining health; new encounters, retries and replays use the revised health curve.

**Payments:** local ledger assertions pass, but the environment blocked the Apple StoreKit test daemon. Actual Apple checkout, approval/cancellation, transaction finish and recovery are not verified end to end. Live sales remain disabled. Reinstall/multi-device wallet recovery and refund reconciliation remain unfinished.

**Devices and release:** physical iPhone/iPad touch ergonomics, audio routes, sustained thermal behavior, full human campaign playtests, signing and App Store submission are still pending.

The repository includes the test scripts and fixtures so results can be reproduced. Passing these checks does not certify App Store readiness.
