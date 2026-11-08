# Shardstrike original soundtrack

Original instrumental music composed and synthesized for Shardstrike on 2026-10-17–19, with the boss percussion arrangements revised on 2026-10-27–28. No third-party recordings, samples, voice, melodies or asset packs are used. The app plays bundled files offline; no streaming account or music subscription is needed.

The hub theme is **Signal in the Dark**: 48 seconds, 80 BPM, D-minor pads, orbiting bells and a restrained heroic motif. Collection uses **Shard Sprint**, a brighter 128 BPM, 15-second loop.

Each boss has an original **percussion-only** arrangement: synthesized kicks, snares, claps, toms, rims, metal impacts, hats and shakers. There are no boss melodies, chords, pads, voices or bass ostinatos. A firm kick/snare groove continues through all 24 bars; later bosses add denser subdivisions, ghost notes and fills. Short impact tails and a small room at one-eighth, one-quarter and one-half beat stay locked to each track's tempo. There are no long quiet breakdowns or slow background layers.

Battle tempo increases by 4 BPM at every sector, from 112 BPM in sector 1 to 168 BPM in sector 15. The steady eighth-note pulse tightens from 268 ms to 179 ms; from sector 8, sixteenth-note percussion reduces the longest gap between attacks to about 107 ms, reaching about 89 ms in the finale. All 360 composed battle bars retain a kick downbeat, snare backbeats and the steady pulse. Each 24-bar score repeats continuously without a quiet breakdown or an extra silent bar at the loop boundary. Each boss keeps its own accents and fills over that continuous rhythm.

Battle mixes target approximately −17 dBFS RMS, with an encoded-peak guard for AAC reconstruction; the released tracks measure −19.54 to −17.05 dBFS RMS and peak below 0.835 full scale. Intensity comes from tempo, rhythm and orchestration rather than increased playback volume. Gameplay playback gain remains 0.16, and short action effects retain a 0.85 mixer gain. The menu and collection recordings are unchanged; collection retains its exact 15-second / 128 BPM timing. Physical-device listening is still required to judge subjective balance.

| Sector | Boss | Theme | BPM | Percussion character |
| --- | --- | --- | --- | --- |
| 1 | Carapace | Emerald Watch | 112 | Heavy shell drums and clipped rim answers |
| 2 | Circuit | Iron Signal | 116 | Metal strikes over a syncopated machine beat |
| 3 | Velocity | Neon Pursuit | 120 | Fast rim runs and skipping double kicks |
| 4 | Nocturne | Violet Frost | 124 | Dry ghost snares and sharp closed hats |
| 5 | Zenith | Solar Oath | 128 | Marching drums and stacked clap accents |
| 6 | Rift | Between Worlds | 132 | Alternating metal hits and offbeat tom replies |
| 7 | Pulse | Heart of Stone | 136 | Heavy floor-tom cycles and rolling fills |
| 8 | Mirage | Afterimage | 140 | Stereo rim call-and-response over a firm backbeat |
| 9 | Prism | Fractured Crown | 144 | Interlocking metal fragments and crisp shakers |
| 10 | Gridlock | Lockstep | 148 | Mechanical sixteenth-note hats and snare doubles |
| 11 | Vortex | Event Horizon | 152 | Triplet drum spirals against a straight backbeat |
| 12 | Phantom | Four Shadows | 156 | Four-position rim answers and ghost-snare rolls |
| 13 | Reaper | Scythe Engine | 160 | Relentless double kicks and driving floor toms |
| 14 | Overload | Storm Circuit | 164 | Broken-beat metal volleys and rapid snare fills |
| 15 | Eclipse | Last Light | 168 | Dense layered drums and cascading finale fills |

All 17 tracks are stereo AAC at 48 kHz / 128 kbps. The complete soundtrack is 12,512,709 bytes (about 12.5 MB). Short drum tails and tempo-synced room taps wrap at boss loop boundaries; collection retains its original melodic room. A 6 ms cosine taper on gameplay tracks suppresses AAC seam clicks; AAC trim metadata preserves musical timing. `GameplayMusic.json` records score durations, titles and rendering statistics and is development metadata, not loaded by the game.

Home, Campaign, Select Hero and Store share continuous menu music without restarting between tabs. Active collection uses the collection track. Combat uses the current boss track after introductions/tutorials finish. The in-run armory and result screens are music-free. Gameplay pause/backgrounding/interruption pauses playback; resume continues from the retained position. The master audio toggle controls music and effects. Only a bounded number of compressed players are retained and preparation is outside frame simulation.

## Rebuild

The checked-in M4A files are release assets. Python/NumPy/SciPy and FFmpeg are development tools only, not application dependencies.

```sh
python3 Tools/generate-menu-music.py /tmp/Shardstrike-MenuTheme.wav
ffmpeg -hide_banner -loglevel error -y -i /tmp/Shardstrike-MenuTheme.wav \
  -c:a aac -b:a 128k -movflags +faststart \
  -metadata title='Signal in the Dark' -metadata artist='Shardstrike' \
  GemRush/Resources/MenuTheme.m4a
python3 Tools/generate-gameplay-music.py
```

Use `python3 Tools/generate-gameplay-music.py --bosses` to rebuild only the 15 boss tracks while preserving the collection recording and its metadata. Use `--only Battle04` or `--only CollectionTheme` to revise one gameplay score. These modes refresh the corresponding `GameplayMusic.json` entries. The generator contains the written rhythmic patterns, synthesized drum designs and deterministic seeds. Keep these sources and this provenance note with the project.

## Verify

`bash test-music-assets.sh` decodes every shipped track and checks duration, stereo, clipping headroom, level, loop boundaries and compressed-size budget. It can use FFmpeg when a developer shell cannot discover Apple's AAC component. `bash test-music-playback.sh` builds a separate native playback check app using the production audio code; opening it exercises playback without touching campaign progress. Physical iPhone listening, silent-switch and system-interruption testing still matter before release.
