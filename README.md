# Morning Call

Morning Call is a deliberately small multiplayer sleep helper for Project Zomboid Build 42.21. It was built for a three-player co-op server, works with any connected-player count, and stays out of the game's time-speed logic.

![Morning Call preview](workshop/MorningCall/preview.png)

## Download and quick start

The player-ready archive is `MorningCall-B42.21.zip` on the project's Releases page. Steam and GOG players can both use the manual package:

1. Download and extract the archive.
2. Copy the extracted `MorningCall` folder into `%UserProfile%\Zomboid\mods\`.
3. Confirm that `%UserProfile%\Zomboid\mods\MorningCall\42\mod.info` exists.
4. Enable `Morning Call` in the game's Mods screen.
5. For multiplayer, add `MorningCall` to the server's `Mods=` list and install the same version for every player.
6. Restart the game and server.

No save reset is required. Stop the server before replacing an installed version.

## What it does

- Shows a persistent top-centre status banner whenever at least one eligible player is asleep, for example `Sleeping 1/3: Alice`.
- Counts connected, living, non-ghost players in the denominator.
- Sorts sleeping display names so the banner remains stable.
- At 05:30 game time every day, wakes any sleeping online players through the vanilla wake-up object change.
- Sends every connected player a six-second message: `Cock-a-doodle-doo! It's 05:30 - morning has arrived.`
- Plays one local rooster crow for each connected client.
- Runs the daily morning alert even if nobody is asleep; only the wake-up step is skipped.
- Re-centres the banner automatically when the resolution changes.
- Does not alter fatigue, sleep duration, player stats, or the game-speed multiplier.

## Compatibility

| Item | Value |
| --- | --- |
| Project Zomboid | Build 42.21.x |
| Mod ID | `MorningCall` |
| Mod version | 1.0.1 |
| Multiplayer | Yes; server and every client load the mod |
| Existing saves | Safe; the mod stores no world or character data |
| MP Fast Forward | Designed to coexist; Morning Call never writes the speed multiplier |
| Workshop dependencies | None |
| GOG edition | Supported through manual installation |

The mod is intentionally fixed at 05:30 and has no sandbox settings, keybinds, saved data, or public API.

## Steam Workshop installation

After the item has been uploaded and has a numeric Workshop ID:

1. Subscribe to the Workshop item on the Steam account hosting the game.
2. Give the Workshop link to every player and have them subscribe.
3. Add the numeric Workshop ID to `WorkshopItems=` in the server INI.
4. Keep `MorningCall` in the server's `Mods=` list.
5. Stop the server before changing the lists, then restart it.

Example with only Morning Call:

```ini
WorkshopItems=1234567890
Mods=MorningCall
```

Example alongside existing entries:

```ini
WorkshopItems=1111111111;1234567890
Mods=SomeOtherMod;MorningCall
```

Replace `1234567890` with the real item ID assigned by Steam. Do not put `MorningCall` in `WorkshopItems`; that field accepts the numeric Steam item ID. Do not put the numeric ID in `Mods`; that field accepts the `id=` value from `mod.info`.

When testing Workshop delivery, move any manually installed `Zomboid\mods\MorningCall` copy out of the mods directory first. Otherwise a local copy can hide a missing or stale Workshop download.

## Manual installation

The manual ZIP remains useful as a fallback:

1. Extract `MorningCall-B42.21.zip`.
2. Put the resulting `MorningCall` folder in `%UserProfile%\Zomboid\mods\`.
3. Ensure the final path is `%UserProfile%\Zomboid\mods\MorningCall\42\mod.info`.
4. Add `MorningCall` to the server's `Mods=` list.
5. Leave `WorkshopItems=` unchanged for this manually distributed version.
6. Install the same version for the host and every joining player, then restart the game and server.

This is the recommended installation method for GOG players. A manually distributed server should use `Mods=MorningCall` without adding Morning Call to `WorkshopItems=`.

## Distribution channels

| Channel | GOG compatible | Updates | Best use |
| --- | --- | --- | --- |
| GitHub Releases | Yes | Manual download | Canonical project home and a small private group |
| Steam Workshop | Steam clients | Automatic subscription updates | Largest PZ audience and Steam-hosted servers |
| Nexus Mods | Yes, primarily manual installation | Nexus/Vortex update notifications | Public non-Steam mirror |
| ModDB | Yes, manual installation | Manual download | Optional secondary public mirror |

### GitHub Releases

GitHub Releases is the best primary home for this project because it keeps the source, README, version history, release notes, ZIP, and checksum together without requiring Project Zomboid to be owned on Steam.

Recommended release details:

- Tag: `v1.0.1-b42.21`
- Title: `Morning Call 1.0.1 for Project Zomboid Build 42.21`
- Asset: `MorningCall-B42.21.zip`
- Notes: `distribution/GITHUB_RELEASE_v1.0.1.md`

### Nexus Mods

Project Zomboid has an active Nexus Mods section, although the PZ community is much larger on Steam Workshop. Upload the same `MorningCall-B42.21.zip` as a **Main File** in the Project Zomboid game section and use `distribution/NEXUS_DESCRIPTION.txt` as the page description.

Suggested listing details:

- Category: `Gameplay` or `Miscellaneous`
- Version: `1.0.1`
- Game version: Build `42.21.x`
- Required files: None
- Installation: Manual installation instructions from this README
- Relevant labels: multiplayer, interface, quality of life, Build 42
- AI disclosure tags: `AI-Generated Content` and `AI Media`

Nexus requires hosted files to be intended for public sharing, so it should not be used merely as private storage for a few friends. The promotional thumbnail was generated with an AI image tool and the mod was developed with substantial AI coding assistance; both must be disclosed accurately on the Nexus listing. Nexus currently lists Project Zomboid in Vortex's supported games, but Morning Call's Vortex installation has not been verified, so manual installation remains the documented path.

### ModDB

ModDB also has a Project Zomboid section and accepts manual mod archives. It is a reasonable mirror but offers less value here than GitHub Releases plus Nexus, so maintaining it is optional.

## Publishing the first Workshop version

The ready-to-upload staging item is installed at:

```text
C:\Users\xboxn\Zomboid\Workshop\MorningCall
```

Its required structure is:

```text
MorningCall/
|-- workshop.txt
|-- preview.png
`-- Contents/
    `-- mods/
        `-- MorningCall/
            |-- common/
            `-- 42/
                |-- mod.info
                |-- poster.png
                `-- media/
```

To publish:

1. Launch Project Zomboid through Steam.
2. Open **Workshop** from the main menu.
3. Choose **Create and update items**.
4. Select the `MorningCall` folder.
5. Confirm the title, description, `Build 42` and `Multiplayer` tags, and **Unlisted** visibility.
6. Choose the option to create a new item and upload it.
7. Accept the Steam Workshop legal agreement if Steam requests it.
8. Copy the assigned numeric ID into the server's `WorkshopItems=` list.
9. Keep the generated numeric `id=` line in `workshop.txt`; it is how later uploads update the same item instead of creating another one.

Unlisted visibility keeps the item out of normal search results while allowing anyone with the link to subscribe. Private visibility is unsuitable for distribution to the other players.

## Updating the Workshop item

1. Make changes in `src/MorningCall`.
2. Increase `modversion` in `src/MorningCall/42/mod.info` when appropriate.
3. Add a short entry to `CHANGELOG.md`.
4. Run `tools/Build-MorningCall.ps1` from PowerShell.
5. Launch Project Zomboid and return to **Workshop > Create and update items**.
6. Select Morning Call, add change notes, and upload the update.
7. Restart Steam or Project Zomboid on clients if Steam has not yet fetched the update.

Never clear or replace the assigned Workshop ID when publishing an update.

## Source layout

```text
MorningCall/
|-- README.md
|-- CHANGELOG.md
|-- assets/
|   `-- MorningCall-preview-source.png
|-- distribution/
|   |-- GITHUB_RELEASE_v1.0.1.md
|   |-- NEXUS_DESCRIPTION.txt
|   `-- NEXUS_UPLOAD_CHECKLIST.md
|-- release/
|   |-- MorningCall-B42.21.zip
|   `-- SHA256SUMS.txt
|-- src/
|   `-- MorningCall/                 # Canonical mod source
|-- tools/
|   `-- Build-MorningCall.ps1        # Builds the ZIP and both staging copies
`-- workshop/
    `-- MorningCall/                 # Repository copy of the upload package
```

The build script copies the canonical source into:

- `workshop/MorningCall/Contents/mods/MorningCall` for repository inspection.
- `%UserProfile%\Zomboid\Workshop\MorningCall` for the in-game uploader.
- `release/MorningCall-B42.21.zip` for manual distribution.
- `release/SHA256SUMS.txt` for download verification.

It does not edit the live server INI and does not upload anything to Steam.

## Privacy and security

Morning Call contains Lua, text metadata, one PNG, and one OGG sound. It contains no executable binaries, installers, analytics, telemetry, advertisements, account integration, or external network requests. Its only network traffic uses Project Zomboid's normal client/server mod-command channel for sleeping state and the morning alert.

## Runtime design

### Server

`MorningCall_Server.lua` polls once per real-time second. It builds a signature from eligible players and only broadcasts a new `sleepState` when that signature changes. A newly loaded client can request the current state using the `hello` command.

The server schedules the next 05:30 using absolute world age hours. Loading a server at or after 05:30 schedules the following morning instead of replaying an old alert. When world time crosses the target, every currently sleeping eligible player is woken, the morning event is broadcast once, and the next target advances by 24 world hours.

### Client

`MorningCall_Client.lua` owns a mouse-transparent, always-on-top UI panel. It displays either the current sleeping-player status or the temporary morning notification. Each client plays its own non-spatial rooster sound when the server sends the morning event.

### Network commands

| Module | Command | Direction | Payload |
| --- | --- | --- | --- |
| `MorningCall` | `hello` | Client to server | Empty table |
| `MorningCall` | `sleepState` | Server to client(s) | `{ total, sleepers }` |
| `MorningCall` | `morning` | Server to clients | `{ time = "05:30" }` |

## Testing checklist

Test with the server stopped before changing installed files.

- [ ] `0/3`: no sleeping banner is visible.
- [ ] `1/3`: banner shows the correct name and denominator.
- [ ] `2/3`: both names appear in stable alphabetical order.
- [ ] `3/3`: all three names appear and normal multiplayer sleep acceleration still works.
- [ ] Waking one player immediately updates the count.
- [ ] Disconnecting, dying, entering ghost mode, and reconnecting update the denominator correctly.
- [ ] Crossing 05:30 at normal speed wakes sleepers once.
- [ ] Crossing 05:30 under accelerated sleep still triggers once.
- [ ] Every client hears one rooster crow and sees one six-second message.
- [ ] Starting the server before 05:30 schedules that morning.
- [ ] Starting the server after 05:30 schedules the following morning without a replay.
- [ ] MP Fast Forward still returns the game to normal speed after waking.
- [ ] `console.txt` contains no Morning Call Lua, sound, or networking errors.
- [ ] A client with the manual copy removed can download and run only the Workshop version.

Current release status: the banner, state synchronization, 05:30 wake-up, and morning message were exercised in private multiplayer play. Version 1.0.1 includes a revised local-emitter sound call; verify the rooster once more before marking a public Nexus release as fully tested.

Useful log file:

```text
%UserProfile%\Zomboid\console.txt
```

Successful server initialization includes:

```text
[MorningCall] server ready; next wake-up scheduled for 05:30
```

The 05:30 event includes:

```text
[MorningCall] 05:30 reached; morning alert sent and sleepers awakened
```

## Troubleshooting

### The mod appears twice

There are two copies with the same `id=MorningCall`, usually one under `Zomboid\mods` and another from Steam Workshop. Move the manual copy out of `Zomboid\mods`, restart the game, and test the Workshop copy again.

### Friends get a missing-mod message

Check that the server contains the numeric Workshop item ID under `WorkshopItems=` and `MorningCall` under `Mods=`. Confirm the item is not Private and that each friend can open its Workshop link.

### The rooster does not play

Confirm `MorningCall_Rooster.ogg` exists under `42/media/sound`, the sound declaration exists under `42/media/scripts`, and every client has the current version. Then inspect `console.txt` for `MorningCallRooster`, `FMOD`, `sound`, or Lua errors.

### The banner does not appear

Verify the mod is enabled on both server and client, then search `console.txt` for `MorningCall` and `OnServerCommand` errors. The banner intentionally remains hidden when nobody is asleep.

## Credits

Rooster audio: **Rooster Crow 02** from SFXMint's animal-call set.

- Source: https://sfxmint.com/sets/animal-calls
- Asset: https://sfxmint.com/dl/rooster-crow-02.ogg
- License: CC0 1.0 Universal

The generated Workshop artwork is an original Morning Call thumbnail and contains no Project Zomboid logos or game assets.

## Development and licensing notes

- The mod was developed with substantial assistance from OpenAI Codex.
- The promotional thumbnail was generated using OpenAI image generation.
- The rooster audio is independently licensed under CC0 as detailed above.
- No open-source licence has been selected for the Morning Call source code. If this repository is made public, normal copyright restrictions apply unless the maintainer adds a licence.
