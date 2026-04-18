# CLAUDE.md — harmonify-standalone

## Project Overview

Harmonify Standalone is a self-contained distribution of the Harmonify "Name that tune" game. It bundles the Vue 3 frontend and the ASP.NET Core music server into a single executable — no Spotify, no cloud, no external dependencies. Players guess tracks from a local music library (FLAC/MP3).

## Repository Structure

This repo (`harmonify-standalone`) is the release and build orchestrator. It contains build scripts and wires together two sub-repos that must be cloned alongside it:

```
harmonify-standalone/          ← this repo (github: MarcinSkic/harmonify-standalone)
├── harmonify-frontend/        ← Vue 3 app (github: MarcinSkic/harmonify)
├── harmonify-music-server/    ← ASP.NET Core server (github: MarcinSkic/harmonify-music-server)
├── build-linux.sh             ← builds Linux binary + .tar.gz archive
├── build-windows.sh           ← builds Windows .exe
├── dist-linux/                ← Linux build output (gitignored)
├── dist-windows/              ← Windows build output (gitignored)
├── CHANGELOG.md               ← release history
└── README.md
```

## Sub-repos

| Repo | Stack | Purpose |
|---|---|---|
| `harmonify-frontend` | Vue 3, TypeScript, Pinia, TailwindCSS, Vite | Game UI + Library + Cover Creator |
| `harmonify-music-server` | ASP.NET Core (.NET 10), C# | Serves local music files, scanning, REST API |

Each sub-repo has its own git history and its own `CLAUDE.md` with stack-specific conventions.

## Build & Release

See [.claude/docs/build.md](.claude/docs/build.md) for full build instructions, artifact paths, and version markers.

## Skills

- When asked to execute/implement a plan (e.g. "zrealizuj plan", "execute plan"), **always invoke the `plan-execution` skill first** before doing anything else.
- When asked to create a GitHub release (e.g. "zrób release", "utwórz release", "wydaj wersję"), **always invoke the `github-release` skill first** before doing anything else.
