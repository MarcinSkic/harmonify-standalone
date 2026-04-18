#!/usr/bin/env bash
set -e

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>  (e.g. v0.1.1)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/harmonify-frontend"
SERVER_DIR="$SCRIPT_DIR/harmonify-music-server"
WWWROOT_DIR="$SERVER_DIR/wwwroot"
OUTPUT_DIR="$SCRIPT_DIR/dist-windows"

echo "==> Building frontend (standalone mode)..."
cd "$FRONTEND_DIR"
pnpm vite build --mode standalone

echo "==> Copying frontend build to music server wwwroot..."
rm -rf "$WWWROOT_DIR"
mkdir -p "$WWWROOT_DIR"
cp -r "$FRONTEND_DIR/dist/." "$WWWROOT_DIR/"

echo "==> Publishing music server as self-contained Windows exe..."
cd "$SERVER_DIR"
dotnet publish harmonify-music-server.csproj \
  -r win-x64 \
  --self-contained \
  -p:PublishSingleFile=true \
  -p:EnableCompressionInSingleFile=true \
  -p:DebugType=None \
  -p:DebugSymbols=false \
  -p:AssemblyName=harmonify-standalone \
  -c Release \
  -o "$OUTPUT_DIR"

echo "==> Cleaning up publish artifacts..."
rm -f "$OUTPUT_DIR/appsettings.json"
rm -f "$OUTPUT_DIR/appsettings.Development.json"
rm -f "$OUTPUT_DIR/web.config"
rm -f "$OUTPUT_DIR"/*.pdb
rm -f "$OUTPUT_DIR"/*.staticwebassets.endpoints.json
rm -rf "$OUTPUT_DIR/wwwroot"
rm -f "$OUTPUT_DIR/aspnetcorev2_inprocess.dll"

echo "==> Renaming exe..."
EXE_NAME="harmonify-standalone-${VERSION}-windows-x64.exe"
mv "$OUTPUT_DIR/harmonify-standalone.exe" "$OUTPUT_DIR/$EXE_NAME"

echo "==> Creating music directory..."
mkdir -p "$OUTPUT_DIR/music"

echo "==> Copying README..."
cp "$SCRIPT_DIR/README.md" "$OUTPUT_DIR/README.md"

echo ""
echo "Done! Output at: $OUTPUT_DIR"
echo "  Exe: $EXE_NAME"
echo ""
echo "To run on Windows:"
echo "  1. Copy dist-windows/ to the target machine"
echo "  2. Place your FLAC files in a music/ folder next to the exe"
echo "  3. Edit appsettings.json to set MusicDirectory and credentials if needed"
echo "  4. Run harmonify-music-server.exe"
echo "  5. Open http://localhost:5192 in a browser"
