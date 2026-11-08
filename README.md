# Shardstrike

A native, offline 3D action game for **iPhone, iPad, and Mac**, built with **Swift, SwiftUI, and SceneKit**.

Collect gems in a 15-second sprint, upgrade your hero's weapon, then face a boss with its own attack pattern. Learn each encounter and advance through a 15-sector alien campaign.

**Current source: 0.12.7 / build 23.** Playable development build; not yet published to the App Store. No ads. The gem shop has a StoreKit 2 test implementation; **live purchases remain disabled**.

Formerly **Gem Rush**. The current app display name, source folder, Xcode project, and scheme retain that name; this repository uses Shardstrike as the project name.

## In the game

- **Five original heroes:** Scout's blaster, Titan's fists, Pulse's cannon, Aegis's returning shield, and Tempest's returning hammer. Each hero has independent weapon upgrades and an unlockable power.
- **Fifteen sequential bosses:** encounters introduce portals, returning discs, shockwaves, clones, crystals, gravity, traps, and darkness. Cleared sectors remain replayable.
- **Manual aiming:** mouse or touch controls with gentle, bounded assistance. Dodge timing, positioning, and weapon travel matter.
- **Focused arenas:** sectors rotate between open space, breakable cover, a jump pad, a moving platform, or a warned floor trap.
- **Persistent progression:** separate hero and run currencies, first-clear rewards, independent hero equipment, and isolated replays prevent repeated gem farming.
- **Original audio:** synthesized weapon sounds and hero efforts, a continuous hub theme, a collection loop, and fifteen percussion-led battle tracks rising from 112 to 168 BPM.
- **Short, platform-specific instructions:** keyboard prompts on Mac and touch prompts on iPhone/iPad, with weapon-specific guidance.

Characters and arena art are constructed from original geometric models in code. The soundtrack is bundled for offline playback. See [music sources and provenance](GemRush/Resources/MUSIC.md).

## Run locally

Requires macOS and Xcode. The last verified toolchain was **Xcode 26.6 / iOS 26.5 SDK**. Deployment targets are **iOS/iPadOS 17+** and **macOS 13+**.

1. Open `GemRush.xcodeproj`.
2. Select the shared **GemRush** scheme.
3. Choose **My Mac**, an iPhone/iPad simulator, or a configured physical device, then Run.

For a physical device, select your own development team and a unique bundle identifier in Signing & Capabilities. Signing credentials and user-specific Xcode state are not included.

Alternatively, build on the current Mac:

```sh
bash build-mac.sh
open "Playable/Gem Rush.app"
```

This creates a locally signed development app, not a notarized distribution package.

| Action | Mac | iPhone / iPad |
| --- | --- | --- |
| Move | W/A/S/D or arrow keys | Left thumbstick |
| Aim and attack | Mouse + click or Space | Right thumbstick |
| Dodge | Shift | Dodge button |
| Reload guns | R | Reload button |
| Use unlocked power | E | Power button |
| Pause | P or Escape | Pause button |

Fists, shields, and hammers do not use ammunition. During collection, clicking or tapping a destination also moves the hero. Backgrounding the app pauses and saves the campaign.

## Engineering

| Area | Main sources |
| --- | --- |
| Campaign, purchases and saved progression | `GameRules.swift`, `PlayerProfile.swift` |
| Aim, collisions and combat abilities | `Aiming.swift`, `BossPatterns.swift`, `HeroCombat.swift` |
| Arena mechanics and procedural art | `ArenaEnvironment.swift`, `ArenaArt.swift`, `SceneArt.swift` |
| Input, simulation and persistence | `GameController.swift` |
| Home, campaign, armory and tutorials | `ContentView.swift` |
| Bounded, precomputed effects and music playback | `GameAudio.swift` |
| StoreKit and durable local purchase delivery | `GemStore.swift`, `PurchaseLedger.swift` |

No third-party application packages are required. Audio generation tools use Python/NumPy/SciPy and FFmpeg during development; the game plays the checked-in assets without those tools.

## Verification

The **October 29, 2026** verification of this version passed **6,046 automated assertions**, plus **48 native combat-audio** and **152 native soundtrack** checks. Mac and generic unsigned iPhone Release builds succeeded. An isolated stress workload covered all 75 hero/boss pairings over 180,000 simulation ticks. These are dated validation results, not a claim of flawless gameplay or App Store approval.

```sh
bash test-rules.sh
bash test-controller.sh
bash test-store-ledger.sh
bash test-performance.sh
```

Tests use temporary storage and do not modify the player's saved campaign. Native playback fixtures can be built with `test-combat-audio.sh` and `test-music-playback.sh`.

See [QA_REPORT.md](QA_REPORT.md) for remaining performance and balance findings. Physical-device touch, heat, audio routes, full human campaign runs, and Apple checkout validation still need work.

## Store and release status

The shared **GemRush Store Testing** scheme uses `StoreTesting.storekit` and separate test saves. It does not charge real money. See [STORE_SETUP.md](STORE_SETUP.md) for the draft catalog and test procedure.

The paid-wallet implementation is local. Reinstall/multi-device recovery, refund reconciliation, and end-to-end Apple checkout must be completed before enabling live sales. Prices are proposals, not a released offer.

Before public release:

- Resolve the known frame hitches and tune newly unlocked heroes for later sectors.
- Playtest the complete campaign on physical iPhones/iPads through TestFlight.
- Finalize app identity, icon, screenshots, privacy/support pages, and accessibility/settings.
- Configure the publishing team and signing; validate a release archive.
- Complete purchase recovery and sandbox testing, or launch with the shop disabled.

## Development

This project was developed with AI-assisted coding and iterated through automated checks, native builds, and hands-on feedback. This public source snapshot excludes local saves, signing material, private account notes, generated builds, and development caches.

Public visibility does not imply an open-source license. No license grant has been selected for this repository.
