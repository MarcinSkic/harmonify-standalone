#!/usr/bin/env bash
set -e

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>  (e.g. v0.1.1)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/harmonify-frontend"
SERVER_DIR="$SCRIPT_DIR/mini-server"
WWWROOT_DIR="$SERVER_DIR/wwwroot"
OUTPUT_DIR="$SCRIPT_DIR/dist-linux"

echo "==> Building frontend (standalone mode)..."
cd "$FRONTEND_DIR"
pnpm vite build --mode standalone

echo "==> Copying frontend build to mini server wwwroot..."
rm -rf "$WWWROOT_DIR"
mkdir -p "$WWWROOT_DIR"
cp -r "$FRONTEND_DIR/dist/." "$WWWROOT_DIR/"

echo "==> Publishing mini server as self-contained Linux binary..."
cd "$SERVER_DIR"
dotnet publish mini-server.csproj \
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
rm -f "$OUTPUT_DIR/web.config"
rm -f "$OUTPUT_DIR"/*.pdb
rm -f "$OUTPUT_DIR"/*.staticwebassets.endpoints.json
rm -rf "$OUTPUT_DIR/wwwroot"

echo "==> Copying README..."
cp "$SCRIPT_DIR/README.md" "$OUTPUT_DIR/README.md"

echo "==> Creating release archive..."
ARCHIVE_NAME="harmonify-standalone-${VERSION}-linux-x64.tar.gz"
ARCHIVE="$OUTPUT_DIR/$ARCHIVE_NAME"
tar -czf "$ARCHIVE" -C "$OUTPUT_DIR" harmonify-standalone README.md

echo ""
echo "Done!"
echo "  Output dir: $OUTPUT_DIR"
echo "  Archive:    $ARCHIVE_NAME"
echo ""
echo "To run on Linux:"
echo "  1. Extract: tar -xzf $ARCHIVE_NAME"
echo "  2. chmod +x harmonify-standalone && ./harmonify-standalone"
echo "  3. Open http://localhost:37450 in a browser"
echo "  4. Point Harmonify at your own Navidrome server from inside the app"
