# Harmonify

"Name that tune" game. Guess tracks from your own music library.

Harmonify does not host music — it plays from **your** [Navidrome](https://www.navidrome.org/)
server. Set that up first (or point Harmonify at one you already run).

## Running

1. Download `harmonify-standalone.exe` from the [latest release](https://github.com/MarcinSkic/harmonify-standalone/releases/latest) and place it in a folder of your choice.

2. Run `harmonify-standalone.exe`

3. Open **http://localhost:37450** in a browser

4. Go to **Navidrome** and sign in with your server address, username and password:
   ```
   Server:   http://192.168.1.10:4533
   Username: your Navidrome user
   Password: your Navidrome password
   ```
   The password is never stored — it only goes to your own server when signing in.

## How to Play

> **Note:** The standalone build supports **local mode only** — no Spotify, no multiplayer rooms.

### 1. Browse your library

**Navidrome** → pick an album or a playlist to see its tracks.
Titles, artists, albums and cover art all come from your server's tags, so anything you fix in
Navidrome shows up here.

### 2. Annotate tracks (optional)

Harmonify keeps its own annotations next to each Navidrome track — the clip to play, a cover image
to show during the round, whether the track is used at all, plus any custom fields you define.
Edit them per track in the track table, or in bulk with CSV (below).

### 3. Annotate in bulk with CSV

**Navidrome** → export the overlay CSV, edit it in a spreadsheet, import it back.
Recognized columns (headers are case-insensitive):

| Column | Description |
|---|---|
| `musicBrainzId` | Matches the track by its MusicBrainz ID |
| `albumId`, `discNumber`, `track`, `title` | Fallback matching for tracks with no MusicBrainz ID |
| `artist` | Shown in track lists and category rules |
| `playbackRange` | Clip to play: `MM:SS - MM:SS`, e.g. `1:20 - 1:50` |
| `previewImageUrl` | URL of a cover image shown during the round |
| `enabled` | `true` or `false` — whether the track is included in games |

Any other column becomes a custom field. Import updates only the columns present in the file; it
never creates tracks.

### 4. Create categories (required for Category game mode)

**Library** → **Categories** → **Add category**.
A category matches tracks by their fields and gives them a display name and a point value.
At least one category must be enabled to start a game in Category mode.

### 5. Start a game

Home → **Play** → **New local**.
Pick an album or a playlist, enter team names, choose your settings, and hit **Play!**

## Configuration

To change the port, create `appsettings.json` next to the exe:

```json
{
  "Urls": "http://localhost:37450"
}
```

## Building

Requires: Node.js, pnpm, .NET 10 SDK

```bash
git clone https://github.com/MarcinSkic/harmonify-standalone
cd harmonify-standalone
git clone https://github.com/MarcinSkic/harmonify harmonify-frontend
bash build-windows.sh v0.5.0   # the version tags the artifact filename
```

Output in `dist-windows/`.
