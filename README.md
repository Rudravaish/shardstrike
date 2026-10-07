# Shardstrike

A native, offline 3D action game for **iPhone, iPad, and Mac**, built with **Swift, SwiftUI, and SceneKit**. Collect gems, upgrade a hero's weapon, and learn the attack patterns of 15 original bosses.

**Status:** playable development build · version 0.7.1 · no ads or real-money purchases. The game has not been published to the App Store.

Formerly **Gem Rush**. The current app display name, source folder, Xcode project, and scheme retain that name; this repository uses Shardstrike as the project name.

## Gameplay

- **A short collection-to-combat loop:** each sector begins with one 15-second gem collection round, followed by weapon upgrades and a boss duel.
- **Five playable heroes:** Scout, Titan, Pulse, Aegis, and Tempest have distinct weapons and unlockable powers. Guns use ammunition; fists do not, and shields and hammers return before another throw.
- **Manual aiming:** touch and mouse controls use gentle, bounded assistance without locking onto a target. A timed dodge helps escape attacks.
- **15 sequential boss encounters:** signature mechanics include portals, shockwaves, clones, gravity, and sweeping barriers. Cleared sectors remain replayable.
- **Focused arenas:** levels rotate between open space, breakable cover, a jump pad, a moving platform, or a warned floor trap. Each duel has at most one additional arena mechanic.
- **Persistent progression:** separate run and hero currencies, first-clear rewards, backward-compatible saves, and isolated replay state prevent replay farming and preserve the main campaign.

All characters and arena art are constructed from original geometric models in code. No external asset packs or package dependencies are required.

## Run locally

Requires macOS and Xcode. The current build has been verified with **Xcode 26.6 and the iOS 26.5 SDK**. Deployment targets are **iOS/iPadOS 17+** and **macOS 13+**.

### Xcode

1. Open `GemRush.xcodeproj`.
2. Select the shared **GemRush** scheme.
3. Choose **My Mac** or an iPhone/iPad simulator, then Run.

For a physical iPhone or iPad, configure your own development team and a unique bundle identifier in Signing & Capabilities. The repository does not contain signing credentials.

### Mac build script

From the repository root:

```bash
bash build-mac.sh
open "Playable/Gem Rush.app"
```

The script builds and locally signs the app for the host Mac. `Playable/Gem Rush.app` is generated locally and is not included in source control. This is a development build, not a notarized distribution package.

### Controls

| Action | Mac | iPhone / iPad |
| --- | --- | --- |
| Move | W/A/S/D or arrow keys | Left thumbstick |
| Aim and fire | Mouse + click or Space | Right thumbstick |
| Dodge | Shift | Dodge button |
| Reload guns | R | Reload button |
| Use unlocked hero power | E | Power button |
| Pause | P or Escape | Pause button |

During collection, clicking or tapping a destination also moves the hero. Backgrounding the app pauses and saves the campaign.

## Engineering

| Area | Implementation |
| --- | --- |
| Rules and progression | `GameRules.swift` and `PlayerProfile.swift` model phases, upgrades, earned level access, first-clear rewards, and save migration. |
| Combat models | `Aiming.swift`, `BossPatterns.swift`, and `HeroCombat.swift` implement swept moving-target collision checks, boss attacks, weapon behavior, and abilities. |
| Interactive arenas | `ArenaEnvironment.swift` models cover durability, jumps, moving platforms, trap timing, and saved arena state. |
| Game coordination | `GameController.swift` connects input, the game loop, SceneKit encounters, damage, pause/resume, and Codable persistence. |
| Rendering and interface | `SceneArt.swift` and `ArenaArt.swift` build the 3D world; `ContentView.swift` provides the SwiftUI campaign map, armory, hero selection, and controls. |

Replay sessions use a temporary copy of campaign gear and skip collection. Returning home or relaunching restores the main campaign. New campaign requires confirmation and resets heroes, currencies, gear, and cleared sectors.

## Verification

Run both suites from the repository root:

```bash
bash test-rules.sh
bash test-controller.sh
```

The scripts compile the production Swift code directly and use temporary test storage. They do not modify the player's saved campaign.

Version 0.7.1 has **2,815 passing automated assertions**: 2,189 model/rules assertions and 626 native controller assertions. Coverage includes progression gates, reward limits, save recovery, moving-target collisions, returning weapons, boss hazards, focused arena layouts, and pause/replay restoration. These are assertions, not 2,815 independent test cases.

Validation also includes successful macOS and unsigned iOS Release builds, plus manual Mac gameplay checks. Physical-device performance, touch ergonomics, and broader difficulty balancing still need testing; no frame-rate or production-readiness claim is made.

This project was developed with AI-assisted coding. Generated changes were reviewed and iterated through automated regression checks, native builds, and hands-on playtesting, including fixes for collision behavior, campaign resets, repeated rewards, and visual clutter.

## Roadmap

- Test and tune combat on physical iPhones and iPads.
- Add sound, a first-play tutorial, and settings.
- Refine difficulty and expand the campaign beyond 15 levels.
- Finish app identity, store artwork, privacy/support pages, signing, and TestFlight preparation.
- Resolve or remove the inactive Store placeholders before release. No StoreKit products, gem payments, or payment processing are implemented.
