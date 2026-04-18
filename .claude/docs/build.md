# Build Documentation — harmonify-standalone

## Prerequisites

- Node.js (LTS)
- pnpm
- .NET 10 SDK

## Build Scripts

Both scripts must be run from the repo root (`harmonify-standalone/`).

### Linux

```bash
./build-linux.sh
```

Steps:
1. Builds frontend with `pnpm vite build --mode standalone`
2. Copies `harmonify-frontend/dist/` → `harmonify-music-server/wwwroot/` (embedded into binary)
3. Publishes `harmonify-music-server` as a self-contained single-file binary for `linux-x64`
4. Packages into a release archive

**Artifacts:**
- `dist-linux/harmonify-standalone` — Linux binary
- `dist-linux/harmonify-linux-x64.tar.gz` — release archive (attach to GitHub release)

### Windows

```bash
./build-windows.sh
```

Same steps as Linux but targets `win-x64`. Can be cross-compiled from Linux.

**Artifacts:**
- `dist-windows/harmonify-standalone.exe` — Windows executable (attach to GitHub release)

## Version Marker

The current version is tracked by **git tags** in the `harmonify-standalone` repo.

To get the latest version:
```bash
git tag --sort=-version:refname | head -1
```

Tags follow semver: `v{MAJOR}.{MINOR}.{PATCH}` (e.g. `v0.1.0`).

## Release Artifacts

Both of these must be attached to every GitHub release:

| File | Platform |
|---|---|
| `dist-linux/harmonify-linux-x64.tar.gz` | Linux x64 |
| `dist-windows/harmonify-standalone.exe` | Windows x64 |
