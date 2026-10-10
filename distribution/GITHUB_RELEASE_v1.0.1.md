# Morning Call 1.0.1 — Project Zomboid Build 42.21

Morning Call is a lightweight multiplayer sleep helper. It shows which players are sleeping and gives the group a consistent 05:30 morning wake-up without changing fatigue or controlling time acceleration.

## Features

- Persistent `Sleeping 1/3: Alice` banner while somebody sleeps.
- Connected living players are counted automatically.
- Sleeping online players wake at 05:30 each in-game day.
- Six-second morning notification for every connected player.
- Rooster-crow audio alert.
- No sandbox settings, keybinds, saved data, or dependencies.
- Designed to coexist with MP Fast Forward.

## Installation

1. Download `MorningCall-B42.21.zip`.
2. Extract the `MorningCall` folder into `%UserProfile%\Zomboid\mods\`.
3. Confirm the final path is `%UserProfile%\Zomboid\mods\MorningCall\42\mod.info`.
4. Enable Morning Call in Project Zomboid.
5. In multiplayer, add `MorningCall` to the server's `Mods=` list and install this same version for every player.
6. Restart the game and server.

This manual package works with both Steam and GOG installations. It does not require a Workshop item.

## Integrity

SHA-256:

```text
483298CBA71596301F719A236723AB3D4B143723FD3B66BACD22ACD44DAC375E  MorningCall-B42.21.zip
```

## Status

The multiplayer banner, state synchronization, scheduled waking, and morning message have been exercised in private multiplayer play. Version 1.0.1 revises rooster playback to use the local player's sound emitter; complete one final audio check before promoting this from a candidate build to a fully tested public release.

See `README.md` for server configuration, architecture, testing, and troubleshooting.
