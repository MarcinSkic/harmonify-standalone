# CLAUDE.md — harmonify-standalone

## Project Overview

Harmonify Standalone is a desktop distribution of the Harmonify "Name that tune" game: the Vue 3 frontend and a small ASP.NET Core server bundled into a single executable — no Spotify, no cloud account. Music comes from the player's own [Navidrome](https://www.navidrome.org/) server, which the app connects to from inside the Library.

## Repository Structure

This repo (`harmonify-standalone`) is the release and build orchestrator. It holds the build scripts and the mini server, and wires them together with the frontend sub-repo, which must be cloned alongside:

```
harmonify-standalone/          ← this repo (github: MarcinSkic/harmonify-standalone)
├── harmonify-frontend/        ← Vue 3 app (github: MarcinSkic/harmonify) — cloned, gitignored here
├── mini-server/               ← ASP.NET Core mini server (tracked in this repo)
├── build-linux.sh             ← builds Linux binary + .tar.gz archive
├── build-windows.sh           ← builds Windows .exe
├── dist-linux/                ← Linux build output (gitignored)
├── dist-windows/              ← Windows build output (gitignored)
├── CHANGELOG.md               ← release history
└── README.md
```

## Mini server

`mini-server/` (.NET 10, C#, namespace `Harmonify.MiniServer`) has exactly two responsibilities:

- serving the embedded frontend — the build copies `harmonify-frontend/dist/` into `mini-server/wwwroot/`, which is embedded into the single-file binary (`Web/EmbeddedFrontend.cs`);
- proxying `/api/linkPreview` (`Web/Router.cs`), so cover images from arbitrary hosts load without CORS trouble. The hosted deployment answers the same route with the serverless function in `harmonify-frontend/api/linkPreview/index.ts` — **the two implementations are one contract, change them together**.

It serves no music, holds no library and has no credentials of its own; Navidrome does all of that.
`harmonify-music-server/` is its archived predecessor and is not part of any build.

## Sub-repos

| Repo | Stack | Purpose |
|---|---|---|
| `harmonify-frontend` | Vue 3, TypeScript, Pinia, TailwindCSS, Vite | Game UI + Library + Cover Creator |

It has its own git history and its own `CLAUDE.md` with stack-specific conventions.

## Build & Release

See [.claude/docs/build.md](.claude/docs/build.md) for full build instructions, artifact paths, and version markers.

## Skills

- When asked to execute/implement a plan (e.g. "zrealizuj plan", "execute plan"), **always invoke the `plan-execution` skill first** before doing anything else.
- When asked to create a GitHub release (e.g. "zrób release", "utwórz release", "wydaj wersję"), **always invoke the `github-release` skill first** before doing anything else.
