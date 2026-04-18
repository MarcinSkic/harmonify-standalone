---
name: github-release
description: "Create a GitHub release for harmonify-standalone. TRIGGER when: user asks to create a release, publish a version, cut a release, 'zrób release', 'utwórz release', 'wydaj wersję'."
---

# GitHub Release Workflow

## 0. Read build documentation

Read `.claude/docs/build.md` to get:
- **GitHub repo** (for CHANGELOG links and `gh release create`)
- **Sub-repos** to include in change analysis
- **Artifact paths** pattern (used in build commands and release upload)
- **CHANGELOG location**

**If `.claude/docs/build.md` does not exist — stop immediately and inform the user.**

Read `.claude/skills/github-release/changelog-example.md` for CHANGELOG format reference.

Resolve the repo root dynamically:
```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

All subsequent commands run from `$REPO_ROOT`.

## 1. Get last version tag

```bash
git tag --sort=-version:refname | head -1
```

Save this as `{PREV_VERSION}` (e.g. `v0.1.0`).

## 2. Analyze changes since last tag

Collect git logs from the root repo and each sub-repo listed in build.md since `{PREV_VERSION}`:

```bash
git log {PREV_VERSION}..HEAD --oneline

cd {SUB_REPO_1}
git log {PREV_VERSION}..HEAD --oneline 2>/dev/null || git log --oneline -20

cd ../{SUB_REPO_2}
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

Read the CHANGELOG file (path from build.md) to confirm `{PREV_VERSION}` matches the first `## v` heading.

Prepend the new entry following the format in `changelog-example.md`:

```markdown
<div align="right">

## {VERSION} ({TODAY_DATE})

</div>

{CHANGELOG_BODY}

**Full Changelog**: https://github.com/{GITHUB_REPO}/compare/{PREV_VERSION}...{VERSION}

```

Use today's date from `currentDate` context. If no previous tag exists, omit the Full Changelog line.

## 6. Commit and push CHANGELOG.md

```bash
git add CHANGELOG.md
git commit -m "release: {VERSION}"
git push origin main
```

## 7. Run both builds

Use the build commands and artifact path patterns from build.md:

```bash
./build-linux.sh {VERSION}
./build-windows.sh {VERSION}
```

## 8. Create GitHub release

Use the GitHub repo and artifact paths from build.md:

```bash
gh release create {VERSION} \
  "{LINUX_ARTIFACT}" \
  "{WINDOWS_ARTIFACT}" \
  --title "{VERSION}" \
  --notes "$(cat <<'NOTES'
{CHANGELOG_BODY}
NOTES
)"
```

The `--notes` content is `{CHANGELOG_BODY}` only — without the `<div>` header and without the Full Changelog line (GitHub renders those separately).

`gh release create` creates the tag on GitHub automatically.

## 9. Fetch to sync tag locally

```bash
git fetch --tags
```

## 10. Report

Print the release URL returned by `gh release create`.
