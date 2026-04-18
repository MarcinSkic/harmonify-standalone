# Harmonify

Multiplayer "Name that tune" game. Guess tracks from your local music library.

## Running

1. Download `harmonify-standalone.exe` from the [latest release](https://github.com/MarcinSkic/harmonify-standalone/releases/latest) and place it in a folder of your choice.

2. Create a `music/` folder next to the exe and put your FLAC or MP3 files inside:
   ```
   harmonify-standalone.exe
   music/
   └── Playlist Name/
       ├── 1. Track Title.flac
       ├── 2. Another Track.flac
       └── ...
   ```

3. Run `harmonify-standalone.exe`

4. Open **http://localhost:51234** in a browser

## How to Play

> **Note:** The standalone build supports **local mode only** — no Spotify, no multiplayer rooms.

### 1. Add your tracks

Place FLAC or MP3 files in `music/` next to the exe, organized into playlist folders:

```
music/
└── My Playlist/
    ├── 1. Never Gonna Give You Up.flac
    ├── 2. Bohemian Rhapsody.mp3
    └── ...
```

ID3 tags (`title`, `artist`, `album`) are read automatically. The filename prefix (`1.`, `2.`, …) is **required** — it becomes the track's source ID used for CSV imports and library matching.

> **Restart required** if you add files while the server is already running.

### 2. Import into the library

Open **http://localhost:51234** → **Library** → click the server import button in the toolbar.  
Select the playlists you want and click **Import selected**.

### 3. Annotate tracks with CSV (optional)

Create a `.csv` file with any of these columns (headers are case-insensitive):

| Column | Description |
|---|---|
| `sourceId` | **Required** — file ID from the music server |
| `tags` | Comma-and-space-separated tags, e.g. `ost, rock` |
| `playbackRange` | Clip to play: `MM:SS - MM:SS`, e.g. `1:20 - 1:50` |
| `enabled` | `true` or `false` — whether the track is included in games |
| `previewImageUrl` | URL of a cover image shown during the round |

### 4. Import the CSV into a playlist

Library → select a playlist in the sidebar → click the **CSV** button in the toolbar → choose your file.  
CSV updates only the fields that are present; it never creates new tracks.

### 5. Create categories (required for Category game mode)

Library → **Categories** → **Add category**.  
A category groups one or more tags under a display name and point value.  
At least one category must be enabled to start a game in Category mode.

### 6. Start a game

Home → **Play** → **New local**.  
Pick a playlist, enter team names, choose your settings, and hit **Play!**

## Configuration

To change the port, music directory, or credentials, create `appsettings.json` next to the exe:

```json
{
  "Urls": "http://localhost:51234",
  "MusicServer": {
    "MusicDirectory": "./music",
    "Username": "harmonify",
    "Password": "mPGhyM8Pqr77hoH4"
  }
}
```

## Building

Requires: Node.js, pnpm, .NET 10 SDK

```bash
git clone https://github.com/MarcinSkic/harmonify-standalone
cd harmonify-standalone
git clone https://github.com/MarcinSkic/harmonify-frontend
git clone https://github.com/MarcinSkic/harmonify-music-server
bash build-windows.sh
```

Output in `dist-windows/`.
