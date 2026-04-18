#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/harmonify-frontend"
SERVER_DIR="$SCRIPT_DIR/harmonify-music-server"
WWWROOT_DIR="$SERVER_DIR/wwwroot"
OUTPUT_DIR="$SCRIPT_DIR/dist-linux"

echo "==> Building frontend (standalone mode)..."
cd "$FRONTEND_DIR"
pnpm vite build --mode standalone

echo "==> Copying frontend build to music server wwwroot..."
rm -rf "$WWWROOT_DIR"
mkdir -p "$WWWROOT_DIR"
cp -r "$FRONTEND_DIR/dist/." "$WWWROOT_DIR/"

echo "==> Publishing music server as self-contained Linux binary..."
cd "$SERVER_DIR"
dotnet publish harmonify-music-server.csproj \
  -r linux-x64 \
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

echo "==> Creating music directory..."
mkdir -p "$OUTPUT_DIR/music"

echo "==> Copying README..."
cp "$SCRIPT_DIR/README.md" "$OUTPUT_DIR/README.md"

echo "==> Creating release archive..."
ARCHIVE="$OUTPUT_DIR/harmonify-linux-x64.tar.gz"
tar -czf "$ARCHIVE" -C "$OUTPUT_DIR" harmonify-standalone music README.md

echo ""
echo "Done!"
echo "  Output dir: $OUTPUT_DIR"
echo "  Archive:    harmonify-linux-x64.tar.gz"
echo ""
echo "To run on Linux:"
echo "  1. Extract: tar -xzf harmonify-linux-x64.tar.gz"
echo "  2. Place your FLAC files in the music/ folder"
echo "  3. chmod +x harmonify-standalone && ./harmonify-standalone"
echo "  4. Open http://localhost:51234 in a browser"
