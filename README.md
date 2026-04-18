# Harmonify

Multiplayer "Name that tune" game. Guess tracks from your local music library.

## Running

1. Download `harmonify-standalone.exe` from the [latest release](https://github.com/MarcinSkic/harmonify-standalone/releases/latest) and place it in a folder of your choice.

2. Create a `music/` folder next to the exe and put your FLAC files inside:
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
