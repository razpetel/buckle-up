# Buckle-Up Plugin Review: Issues

> Generated: 2026-02-04
> Review methodology: Multi-agent analysis against context-engineering, claude-4-best-practices, everything-claude-code research + official Claude Code documentation

## Fixed (2026-02-04)

| Issue | Fix |
|-------|-----|
| #1 Directory structure | Moved `references/`, `scripts/`, `templates/` into `skills/buckle-up/` |
| #2 Missing hooks | Created 3 hook scripts in `templates/hooks/` |
| #3 README incomplete | Added Insights Integration section |
| #5 Clone URL | Verified: repo exists and is public |
| #6 Invocation wording | Changed "Auto-discover" → "Choose interactively" |

---

## Critical (Blocking)

### 1. Directory Structure Mismatch — Skill Won't Resolve References

**Location:** `skills/buckle-up/SKILL.md` lines 113-151 (References section)

**Problem:** SKILL.md references files using relative paths like `references/scoring-matrix.md`, but these directories exist at the **project root**, not inside `skills/buckle-up/`.

**Actual structure:**
```
buckle-up/
├── skills/buckle-up/
│   ├── SKILL.md          ← HERE
│   └── assets/banner.txt
├── references/           ← NOT in skills/buckle-up/
├── agents/               ← NOT in skills/buckle-up/
├── scripts/              ← NOT in skills/buckle-up/
└── templates/            ← NOT in skills/buckle-up/
```

**Impact:** When Claude loads the skill and tries to read referenced files, the paths won't resolve. The skill becomes a documentation stub without access to its supporting materials.

**Fix options:**
1. Move `references/`, `agents/`, `scripts/`, `templates/` INTO `skills/buckle-up/`
2. OR update SKILL.md to use paths from project root (but this breaks skill portability)

**Recommendation:** Option 1 — move directories into the skill folder. This follows the plugin pattern where skills are self-contained.

---

## High

### 2. Missing Hook Template Scripts

**Location:** `templates/hooks/` (does not exist)

**Problem:** The implementation plan (`docs/plans/2026-02-02-buckle-up-implementation.md`) specifies three hook scripts that should exist:
- `templates/hooks/pre-commit-test-gate.sh`
- `templates/hooks/post-edit-tdd-reminder.sh`
- `templates/hooks/stop-session-log.sh`

The `templates/` directory only contains `claude-md-section.md`.

**Impact:** The config-writer-agent references hooks in its Apply phase but has no templates to work from. Users expecting hook configuration will get nothing.

**Fix:** Create the three hook scripts or remove hook generation from the config-writer-agent scope.

---

### 3. README Missing Core Features

**Location:** `README.md`

**Problem:** README documents the flow but doesn't mention:
- The three agents (research-agent, config-writer-agent, verification-agent)
- Insights integration (`/insights` auto-run, usage data parsing)
- The new catalogue discovery options (clone readymade vs enter path)

These are documented in SKILL.md but users reading README won't know they exist.

**Impact:** User confusion about what the plugin actually does.

**Fix:** Add "Agents" section and mention insights integration in README.

**Note:** README *does* have an Agents table - issue partially addressed. Verify the table matches current agent capabilities.

---

## Medium

### 4. Agents Not in Plugin `agents/` Namespace

**Location:** `agents/` at project root

**Problem:** Per official Claude Code docs, plugin agents should be in the plugin's `agents/` directory. But the plugin structure is:
```
buckle-up/
├── .claude-plugin/plugin.json
├── agents/               ← At root (correct for plugin)
└── skills/buckle-up/     ← Skill here
```

This is actually **correct** for plugins — agents at plugin root. However, SKILL.md implies these agents are skill-specific, creating conceptual confusion.

**Impact:** Low — technically correct but semantically confusing.

**Recommendation:** Add clarifying comment in SKILL.md that agents are at plugin level, loaded with the plugin.

---

### 5. Clone URL Unverified

**Location:** `SKILL.md` line 85

**Problem:** SKILL.md references:
```
git clone https://github.com/razpetel/research-catalogue.git ~/research-catalogue
```

This repository may or may not exist publicly.

**Impact:** If repo doesn't exist, "Clone readymade catalogue" option fails.

**Fix:** Verify repo exists and is public, or create it before plugin release.

---

### 6. Invocation Section Says "Auto-discover" But Flow Doesn't

**Location:** `SKILL.md` lines 17-19

**Problem:**
```markdown
## Invocation
- `/buckle-up` — Auto-discover catalogue
```

But the Catalogue Discovery section (lines 80-92) immediately asks the user to choose — no auto-discovery happens.

**Impact:** Documentation inconsistency.

**Fix:** Change to:
```markdown
- `/buckle-up` — Choose catalogue interactively
```

---

## Low

### 7. Version Drift

**Location:** `.claude-plugin/plugin.json` vs `docs/plans/2026-02-02-buckle-up-implementation.md`

**Problem:** plugin.json says `"version": "1.2.0"` but implementation plan targets `1.0.0`.

**Impact:** Minor — just indicates evolution without plan updates.

**Recommendation:** Either update implementation plan or add CHANGELOG.md.

---

### 8. DOT Graph in SKILL.md May Not Render

**Location:** `SKILL.md` lines 23-77

**Problem:** The DOT graph syntax is embedded in markdown. Claude can interpret it, but GitHub/other renderers won't render DOT graphs — they'll show raw code.

**Impact:** Documentation looks messy in GitHub preview.

**Recommendation:** Either:
- Convert to Mermaid (GitHub renders it)
- Add rendered PNG alongside
- Accept it's for Claude's consumption only

---

### 9. `allowed-tools` Not Specified in SKILL.md Frontmatter

**Location:** `SKILL.md` lines 1-4

**Problem:** Official docs recommend specifying `allowed-tools` in skill frontmatter if the skill should restrict tool access. Buckle-up doesn't specify this.

**Impact:** None if intended — skill inherits full tool access. But if buckle-up should be read-only during interview phase, this could be a security consideration.

**Recommendation:** Intentional omission is fine; just verify this is desired behavior.

---

### 10. Design Document Drift

**Location:** `docs/plans/2026-02-02-buckle-up-design.md`

**Problem:** Design doc flow doesn't show the verification-agent in the pipeline. SKILL.md does.

**Impact:** Historical document is stale.

**Recommendation:** Mark design doc as superseded or update it.

---

## Verified Correct

These were checked and found to be properly implemented:

| Item | Status |
|------|--------|
| Agent YAML frontmatter format | Correct (name, description, model, tools) |
| Agent descriptions include examples | Correct |
| Scoring dimensions (5) | Consistent across files |
| Interview questions (10) | Consistent with "5-10" promise |
| Tool categories (7) | Consistent across files |
| State file schema | Consistent across all references |
| Token budget guidance | Present in `references/guidance.md` |
| Verification rules | Comprehensive 4-dimension check |
| Plugin manifest location | Correct (`.claude-plugin/plugin.json`) |

---

## Summary

| Severity | Count | Action Required |
|----------|-------|-----------------|
| Critical | 1 | Fix before release |
| High | 2 | Fix before release |
| Medium | 3 | Fix when convenient |
| Low | 4 | Optional cleanup |

**Primary blocker:** Directory structure mismatch (#1) prevents skill from functioning.

**Recommended fix order:**
1. Move `references/`, `agents/`, `scripts/`, `templates/` into `skills/buckle-up/`
2. Create missing hook scripts OR remove from scope
3. Update SKILL.md invocation wording
4. Verify clone URL exists
