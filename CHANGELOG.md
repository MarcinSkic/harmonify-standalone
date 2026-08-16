<div align="right">

## v0.4.3 (2026-08-16)

</div>

## Fixes & Improvements

- Highlighted the team that won a takeover (wheel spin or single candidate) in the scoring panel, so it's clear who receives the points
- Added the configured music server URL to the "Import from music server" dialog title

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.4.2...v0.4.3

<div align="right">

## v0.4.2 (2026-08-15)

</div>

## Fixes & Improvements

- Added a button to show the track ID
- Added the ability to award negative points
- Added an indicator showing which team's round it is
- Added a picker wheel for take overs
- Changed the app port to avoid the ephemeral port range

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.4.1...v0.4.2

<div align="right">

## v0.4.1 (2026-05-07)

</div>

## UI tweaks

Small layout improvements across game views:

- Results tab layout adjusted for laptop screen sizes
- Track preview moved to the left side in round breakdown
- Points badge repositioned to the corner of category cards

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.4.0...v0.4.1

<div align="right">

## v0.4.0 (2026-04-27)

</div>

## Category limit modes

When playing in category mode, a new setting controls how often teams can pick the same category:
- **None** — no restriction (default)
- **No-streak** — a team cannot pick the same category twice in a row
- **Once each** — each team can pick each category only once per cycle, then the cycle resets

## Category Sets

Categories are now organized into sets linked to playlists. Each set defines its own ordering of categories, independent of other sets.

- Full CRUD management of category sets in the library
- Drag-and-drop reorder of members within a set
- CSV import/export for set members
- Linking a playlist to a set in the playlist sidebar
- Multi-playlist selection in game setup — categories are gathered from all sets linked to the selected playlists and merged by ID
- Per-playlist dynamic category type with configurable points in game settings

## Improved track import from music server

- Tracks now use their full relative path as `sourceId`, preventing collisions across folders
- Re-importing a playlist updates existing tracks in place instead of creating duplicates
- The enabled/disabled state is now tracked per playlist rather than globally, so disabling a track in one playlist does not affect others
- CSV import still works by matching on the numeric tail of the old ID format

## Playlist cover art

Covers are now shown throughout the UI:
- Import dialog displays cover thumbnails in the playlist grid
- Library sidebar shows a square cover thumbnail next to each playlist name
- Game setup shows playlists as cover cards instead of a flat button list

## Playlist info saved in game results

Playlist names and covers are stored alongside game results. The Results tab now shows which playlist each track came from, with its cover art.

## Random track start

A new playback setting controls where in the track playback begins:
- **Beginning** — always starts from the start (default)
- **Random** — starts at a random position within a configurable percentage range

An override checkbox lets the host force a specific start position for the current round regardless of the setting.

## Standard points in random mode

Random mode now has a configurable standard points value. The scoring form shows three quick-award buttons: **Full**, **Full + Bonus**, and **Bonus**, so points can be awarded in one click without typing a number.

## Track categories shown during scoring

During the scoring phase, all game categories the current track belongs to are displayed as badges above the preview image. The category that was being played (with its points) appears last. This can be toggled via a game setting (`Show track categories`).

## Bonus points renamed

The "artist/album" label in the scoring form has been renamed to **Bonus points** to be more descriptive of its purpose (partial guesses: artist name, album name, etc.).

## Show answer button disabled until music plays

The "Show Answer" button is now disabled until the track has actually started playing, preventing accidental reveals before music loads.

## Cheat input improvements

The cheat input now accepts the full `sourceId` format (e.g. `folder/subfolder/track.flac`) in addition to the short numeric form, and can match any track in the database regardless of the currently selected playlist.

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.3.0...v0.4.0

<div align="right">

## v0.3.0 (2026-04-21)

</div>

## Game Results

- Detailed results view after each game with per-round breakdown
- Browse full game history with album covers and team scores per round
- Shared result tabs used in both local and online modes

## Takeover

- Non-current teams can now steal points by scoring at least half the category's value
- Stolen scores shown with a distinct Zap icon in amber
- Fixed inverted team detection and corrected tooltip text

## Leaderboard

- Unified team score display with shared `TeamScoreItem` component
- Current team highlighted with an icon in the local leaderboard
- Final results screen replaced with leaderboard-style view

## UI Improvements

- Wider category tiles and larger points badge in CategoryPicker
- Points displayed with a Star icon instead of plain "pts" text
- Removed redundant "Round X" heading from game view
- Various readability tweaks for projector / large-screen use

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.2.0...v0.3.0

<div align="right">

## v0.2.0 (2026-04-19)

</div>

## Library

- Add hover card with album and preview images on track thumbnail
- Show preview image peeking behind album cover in track row

## Leaderboard

- Auto-advance to next round with configurable duration

## Categories

- Dynamic grid columns based on item count
- CSV export and import for categories

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.1.1...v0.2.0

<div align="right">

## v0.1.1 (2026-04-18)

</div>

## Bug Fixes

- Fix: serve fallback index.html from embedded file provider

## Build

- Add Linux standalone build

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v0.1.0...v0.1.1
