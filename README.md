# Harmonify

Multiplayer "Name that tune" game. Guess tracks from your local music library.

## Running

1. Place your FLAC files in the `music/` folder:
   ```
   music/
   └── Playlist Name/
       ├── 1. Track Title.flac
       ├── 2. Another Track.flac
       └── ...
   ```

2. Run `harmonify-standalone.exe`

3. Open **http://localhost:51234** in a browser

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
