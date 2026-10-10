# Nexus Mods publishing checklist

This document contains the page settings and assets for publishing Morning Call in the Project Zomboid section of Nexus Mods. It is a preparation checklist only; it does not publish anything.

## Page details

| Field | Value |
| --- | --- |
| Game | Project Zomboid |
| Name | Morning Call |
| Summary | Multiplayer sleep status, a daily 05:30 wake-up, morning message, and rooster alert for Build 42.21. |
| Category | Gameplay; use Miscellaneous if Gameplay is unavailable during submission |
| Version | 1.0.1 |
| Build | 42.21.x |
| Required mods | None |
| Adult content | No |
| Archive | `release/MorningCall-B42.21.zip` |
| Description | `distribution/NEXUS_DESCRIPTION.txt` |
| Primary image | `workshop/MorningCall/preview.png` |

## Disclosure and content tags

Apply the tags that are available and accurately match the release:

- Multiplayer
- User Interface
- Quality of Life
- Build 42
- AI-Generated Content
- AI Media

The final two disclosures are required for an accurate listing: the implementation was produced with substantial OpenAI Codex assistance, and the promotional thumbnail was generated using OpenAI image generation.

## File upload

1. Create a new mod under the Project Zomboid game page.
2. Fill in the page fields above.
3. Paste the contents of `NEXUS_DESCRIPTION.txt` into the long description.
4. Upload `MorningCall-B42.21.zip` as a Main File with version `1.0.1`.
5. Use a file description such as: `Build 42.21 multiplayer sleep helper. Extract the MorningCall folder into %UserProfile%\Zomboid\mods.`
6. Upload `workshop/MorningCall/preview.png` as the primary image and disclose it as AI Media.
7. Confirm that the archive preview shows `MorningCall/42/mod.info` at the correct depth.
8. Wait for the file's security scan to complete before sharing the page.

## Permissions requiring the maintainer's decision

No open-source licence is currently attached to the code. Choose the Nexus permissions deliberately rather than accepting assumptions about redistribution, modification, conversion, or use in other mods. The bundled rooster audio is CC0, but that does not automatically license the Lua code or generated artwork under CC0.

## Pre-publication gate

- [x] Correct Build 42 folder structure.
- [x] ZIP contains the top-level `MorningCall` folder.
- [x] No executables or nested archives.
- [x] CC0 rooster source is credited.
- [x] AI disclosures are written into the page draft.
- [x] SHA-256 checksum generated.
- [x] Re-test the rooster alert at 05:30 using version 1.0.1.
- [ ] Decide the source-code and redistribution licence/permissions.
- [ ] Create the public GitHub repository and release.
- [x] Replace any candidate-status wording after the audio check passes.
- [ ] Publish the Nexus page and record its mod ID/URL.
- [ ] Add the live Nexus URL to the GSVS Projects Hub.

Nexus Mods requires uploaded files to be intended for public sharing. Do not use the published page as private storage.
