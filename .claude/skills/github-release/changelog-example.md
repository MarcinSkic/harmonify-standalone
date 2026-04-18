# CHANGELOG.md Format Example

Each release entry follows this structure. Use it as a reference when writing new entries.

---

```markdown
<div align="right">

## v3.2.0 (2024-06-22)

</div>

## Section Title

![screenshot description](./changelog/9.png)

Short description of the change. Notable points:
- Bullet point one
- Bullet point two
- Bullet point three

## Another Section

![screenshot description](./changelog/10.png)

Description of another change.

**Full Changelog**: https://github.com/MarcinSkic/harmonify-standalone/compare/v3.1.0...v3.2.0
```

---

## Rules

- The `<div align="right">` wrapper right-aligns the version heading in GitHub's Markdown renderer.
- Each section gets its own `##` heading with an optional screenshot.
- Screenshots go in `changelog/` folder next to `CHANGELOG.md`, named sequentially.
- The **Full Changelog** line is always last, linking `{PREV_VERSION}...{NEW_VERSION}`.
- Omit the **Full Changelog** line for the very first release (no previous tag).
- Entries are prepended — newest version at the top of the file.
