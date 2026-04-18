---
name: github-release
description: "Create a GitHub release for harmonify-standalone. TRIGGER when: user asks to create a release, publish a version, cut a release, 'zrób release', 'utwórz release', 'wydaj wersję'."
---

# GitHub Release Workflow

## 0. Read build documentation

Read `.claude/docs/build.md` to confirm artifact paths and version marker location.
**If `.claude/docs/build.md` does not exist — stop immediately and inform the user. Do not proceed until the file is created.**
Read `.claude/skills/github-release/changelog-example.md` for CHANGELOG format reference.

All commands below run from the repo root (`harmonify-standalone/`). Use absolute path `/home/marcin/repos/harmonify/` if the shell CWD is elsewhere.

## 1. Get last version tag

```bash
cd /home/marcin/repos/harmonify
git tag --sort=-version:refname | head -1
```

Save this as `{PREV_VERSION}` (e.g. `v0.1.0`).

## 2. Analyze changes since last tag

Collect git logs from all three repos since `{PREV_VERSION}`:

```bash
cd /home/marcin/repos/harmonify
git log {PREV_VERSION}..HEAD --oneline

cd harmonify-frontend
git log {PREV_VERSION}..HEAD --oneline 2>/dev/null || git log --oneline -20

cd ../harmonify-music-server
git log {PREV_VERSION}..HEAD --oneline 2>/dev/null || git log --oneline -20
```

Read the commit messages and identify:
- **Breaking changes** (rename, removal, behavior change) → suggests **Major**
- **New features** (new screen, new command, new game mode) → suggests **Minor**
- **Fixes and small improvements** only → suggests **Patch**

## 3. Propose version with AskUserQuestion

Based on your analysis, calculate what each bump would produce from `{PREV_VERSION}`:
- Major: increment first number, reset others (e.g. `v0.1.0` → `v1.0.0`)
- Minor: increment second number, reset patch (e.g. `v0.1.0` → `v0.2.0`)
- Patch: increment third number (e.g. `v0.1.0` → `v0.1.1`)

Use **AskUserQuestion** with 3 options. Put your recommendation first and mark it "(Recommended)". Include one-line reasoning in the description of each option.

Example question:
> "Jaka wersja? Przeanalizowałem zmiany od {PREV_VERSION}."
> - Minor — v0.2.0 (Recommended) — nowe funkcje: X, Y
> - Patch — v0.1.1 — tylko poprawki i ulepszenia
> - Major — v1.0.0 — brak breaking changes, ale możliwe jeśli uznasz za milestone

Wait for user selection. Save result as `{VERSION}`.

## 4. Ask for changelog description

Ask the user for release description. Tell them to paste raw Markdown (sections, bullet points, screenshot refs). Use AskUserQuestion or just ask in text — whatever fits the UX.

Wait for the answer. Save as `{CHANGELOG_BODY}`.

## 5. Update CHANGELOG.md

Read `/home/marcin/repos/harmonify/CHANGELOG.md` to get `{PREV_VERSION}` from the first `## v` heading (confirm it matches what you found in step 1).

Prepend the new entry to `CHANGELOG.md` following the format in `changelog-example.md`:

```markdown
<div align="right">

## {VERSION} ({TODAY_DATE})

</div>

{CHANGELOG_BODY}

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/{PREV_VERSION}...{VERSION}

```

Use today's date from `currentDate` context. If no previous tag exists, omit the Full Changelog line.

## 6. Commit CHANGELOG.md

```bash
cd /home/marcin/repos/harmonify
git add CHANGELOG.md
git commit -m "docs: add changelog for {VERSION}"
```

## 7. Create git tag

```bash
cd /home/marcin/repos/harmonify
git tag {VERSION}
```

## 8. Run both builds

```bash
cd /home/marcin/repos/harmonify
./build-linux.sh
./build-windows.sh
```

Expected artifacts (from build.md):
- `dist-linux/harmonify-linux-x64.tar.gz`
- `dist-windows/harmonify-standalone.exe`

## 9. Create GitHub release

```bash
cd /home/marcin/repos/harmonify
gh release create {VERSION} \
  "dist-linux/harmonify-linux-x64.tar.gz" \
  "dist-windows/harmonify-standalone.exe" \
  --title "{VERSION}" \
  --notes "$(cat <<'NOTES'
{CHANGELOG_BODY}
NOTES
)"
```

The `--notes` content is `{CHANGELOG_BODY}` only — without the `<div>` header and without the Full Changelog line (GitHub renders those separately).

## 10. Report

Print the release URL returned by `gh release create`.
