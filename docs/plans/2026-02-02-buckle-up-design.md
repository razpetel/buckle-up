# Buckle-Up: Project Setup Wizard

## Overview

**buckle-up** is a Claude Code plugin that interviews users about their project needs, scores tools from a research catalogue, and configures the optimal Claude Code setup (plugins, MCPs, hooks, CLAUDE.md).

**Invocation:** `/buckle-up` or `/buckle-up /path/to/catalogue`

**Core insight:** Use the research you've already done to make smart, minimal tool selections instead of manually evaluating 30+ options for each project.

---

## Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        /buckle-up                               │
└─────────────────────────────┬───────────────────────────────────┘
                              ▼
                    ┌─────────────────┐
                    │ Catalogue found? │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
         [./research]  [~/research-   [Prompt user
                        catalogue]     for path]
              │              │              │
              └──────────────┴──────────────┘
                              ▼
                    ┌─────────────────┐
                    │  Index stale?   │
                    └────────┬────────┘
                             │
                    yes ─────┼───── no
                      │      │      │
                      ▼      │      │
              ┌─────────────┐│      │
              │ Rebuild     ││      │
              │ (show       ││      │
              │ progress)   ││      │
              └──────┬──────┘│      │
                     └───────┴──────┘
                              ▼
                    ┌─────────────────┐
                    │ Previous run?   │
                    └────────┬────────┘
                             │
                    yes ─────┼───── no
                      │      │      │
                      ▼      │      │
              ┌─────────────┐│      │
              │Resume       ││      │
              │Upgrade      ││      │
              │Re-interview ││      │
              │Reset        ││      │
              └──────┬──────┘│      │
                     └───────┴──────┘
                              ▼
                    ┌─────────────────┐
                    │ Detect existing │
                    │ config          │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Interview       │
                    │ (5-10 questions)│
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Depth questions │
                    │ (if ambiguous)  │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Score all tools │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Top 10 + ensure │
                    │ category coverage│
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Deep research?  │
                    │ [Yes / No]      │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ LLM reasoning   │
                    │ → minimal set   │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Present plan    │
                    │[Apply/Edit/     │
                    │ Explain]        │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │ Apply piece by  │
                    │ piece (confirm) │
                    └────────┬────────┘
                              ▼
                    ┌─────────────────┐
                    │      Done       │
                    └─────────────────┘
```

---

## Catalogue Discovery

Check in order:
1. `./research/catalogue.md` (project-local)
2. `~/research-catalogue/catalogue.md` (global default)
3. Prompt user for path

If no catalogue found:
```
No research catalogue found.

Options:
  [Create with fomo-researcher] — Install plugin and run /research
  [Point to existing]           — Enter path to catalogue
  [Cancel]                      — Exit buckle-up
```

---

## Indexing

**Index location:** `{catalogue-dir}/.toolshed-index.json`

Lives next to the catalogue so it travels with the research repo.

**Staleness check:** Compare SHA-256 hash of `catalogue.md` with cached hash. Rebuild if different.

**Index generation:** LLM reads all reports and generates structured data.

**Progress display:**
```
Indexing catalogue...
  [████████░░░░░░░░] 12/32 tools
```

**Index schema:**
```json
{
  "version": "1.0",
  "catalogueHash": "a3f2b1c4...",
  "generatedAt": "2026-02-02T20:30:00Z",
  "tools": [
    {
      "slug": "superpowers",
      "name": "obra/superpowers",
      "category": "orchestration",
      "teamFit": ["solo", "small-team", "large-team"],
      "maturity": "very-positive",
      "complexity": "moderate",
      "tokenEfficiency": "neutral",
      "autonomy": "human-in-loop",
      "keywords": ["TDD", "skills", "brainstorm", "review", "workflow"],
      "bestFor": "structured AI-assisted development",
      "warnings": [],
      "stars": 42400,
      "requiresMcp": [],
      "complementsTools": ["agent-browser", "mem0"],
      "overlapsTools": ["oh-my-claudecode", "cc10x"]
    }
  ]
}
```

**Schema validation:** After generation, validate required fields. Missing fields → re-prompt LLM for that tool.

---

## Interview

**Goal:** Extract maximum signal with minimum questions (5-10).

**Method:** Conversational dialogue, one question at a time. Save progress after each answer to state file (crash recovery).

### Question Bank

| # | Question | Type | Dimension |
|---|----------|------|-----------|
| 1 | What are you building? | Single-select | Project type |
| 2 | Solo or team? | Single-select | Team size |
| 3 | Hobby/learning or production? | Single-select | Maturity needs |
| 4 | How token-conscious are you? (1-3) | Scale | Token efficiency |
| 5 | How much do you want to stay in the loop? (1-3) | Scale | Autonomy |
| 6 | Do you need memory across sessions? | Yes/No/Maybe | Memory |
| 7 | Will you need browser automation? | Yes/No/Maybe | Browser |
| 8 | Prefer minimal setup or feature-rich? | Spectrum | Complexity |
| 9 | Any existing tools you want to keep? | Free text | Constraints |
| 10 | Anything else I should know? | Free text | Open |

**Options for Q1 (project type):**
- CLI tool
- Web app
- API service
- Library/package
- Monorepo
- Other: ___

**Options for Q2 (team size):**
- Solo developer
- Small team (2-5)
- Larger team (6+)

**Options for Q3 (maturity):**
- Hobby/learning project
- Production/professional

**Depth questions (only if ambiguous):**
- "You said 'maybe' for memory — what's the use case?"
- "You want autonomous but also low token usage — which matters more?"
- "You mentioned keeping X — what do you use it for?"

---

## Scoring Matrix

### Dimensions (5 total)

| Dimension | 0 | 1 | 2 | 3 |
|-----------|---|---|---|---|
| **Team fit** | Wrong size entirely | Usable but not ideal | Good fit | Explicitly built for this |
| **Maturity** | Beta/warnings | Mixed sentiment | Positive, stable | Very Positive, production-proven |
| **Complexity match** | Way over/under | Slight mismatch | Good match | Perfect match |
| **Token efficiency** | Token-heavy | Average | Efficient | 90%+ reduction claims |
| **Autonomy match** | Wrong model entirely | Partial fit | Good fit | Exactly what they want |

### Weight Multipliers

Derived from interview answers:

| Interview signal | Weight adjustment |
|------------------|-------------------|
| "Autonomous overnight runs" | Autonomy × 2 |
| "Token-conscious: 3" | Token efficiency × 2 |
| "Production" | Maturity × 1.5 |
| "Minimal setup" | Complexity × 1.5 (inverted: lower complexity scores higher) |

### Bonuses

| Condition | Bonus |
|-----------|-------|
| Tool supports "maybe" feature (memory, browser) | +1 |
| Tool complements existing tool user wants to keep | +1 |
| Tool explicitly recommended for user's project type | +1 |

### Penalties

| Condition | Penalty |
|-----------|---------|
| Warning in report (security, stability, etc.) | -1 per warning (max -3) |
| Tool conflicts with existing tool user wants to keep | -2 |

### Formula

```
score = Σ(dimension_score × weight_multiplier) + bonuses - penalties
```

Max theoretical score: ~25 points (before penalties)

### Tiebreaker

1. Sentiment (Very Positive > Positive > Mixed)
2. Stars (if sentiment ties)

---

## Category Coverage

**Categories:**

| Category | Tools |
|----------|-------|
| Orchestration | superpowers, oh-my-claudecode, ralph, multiclaude, Auto-Claude, cc10x, GSD |
| Memory | Mem0, OrchestKit (memory layer) |
| Methodology | PIV Loop, Context Engineering, HDD, Claude 4 Best Practices |
| Browser | agent-browser |
| Debugging/Observability | claude-trace |
| Infrastructure | Railway, SourceSync |
| Reference | Vector DB Comparison, Vibe Code Camp Summarizer |

**Selection rule:** Top 2 per relevant category, then fill remaining slots (up to 10) by raw score.

"Relevant category" = user expressed need (e.g., skip Browser if user said "No" to browser automation).

---

## Deep Research (Optional)

After identifying top 10:

```
Top 10 candidates identified:
  1. superpowers (14 pts)
  2. ralph (13 pts)
  3. Mem0 (12 pts)
  ...

Check web for updates on these tools?
  [Yes] — Quick search for recent news/releases
  [No]  — Use cached reports only (faster)
```

**If Yes:** For each tool, run:
- Brave search: `"{tool name}" 2026`
- GitHub API: Check stars, last commit date
- Compare with indexed data, flag significant changes

**Output:**
```
Updates found:
  • superpowers: 42.4K → 45.1K stars (+6%)
  • Mem0: New v2.0 release (Jan 28)
  • ralph: No significant changes

[Continue with scoring] [Re-read updated reports]
```

---

## LLM Reasoning

**Prompt template:** (`scripts/selection-reasoning.md`)

```markdown
## Context

User needs (from interview):
{interview_summary}

Top 10 candidates with scores:
{scored_tools_table}

Existing tools user wants to keep:
{existing_tools}

## Task

Select the MINIMAL set of tools that:
1. Covers ALL stated user needs
2. Has NO overlapping functionality (pick one per function)
3. Respects user's complexity preference
4. Works with existing tools (no conflicts)

## Output Format

### Selected Tools
For each tool:
- Name
- Why selected (cite specific user need it addresses)
- What it provides that nothing else does

### Excluded Tools (from top 10)
For each excluded tool:
- Name
- Why excluded (overlap with X / user said Y / warning Z)

### Methodology References
List any methodology reports that should be added to CLAUDE.md as references (not installed, just linked).
```

---

## Output Presentation

```
═══════════════════════════════════════════════════════════════
  BUCKLE-UP: Your Optimal Toolset
═══════════════════════════════════════════════════════════════

Based on: Solo developer, web app, production, autonomous,
          memory needed, token-conscious

INSTALL:
┌───────────────────────────────────────────────────────────────┐
│ MCPs:                                                         │
│   • brave-search              (web/reddit/twitter search)     │
│   • mem0                      (cross-session memory)          │
│                                                               │
│ Plugins:                                                      │
│   • superpowers@obra          (orchestration + TDD workflow)  │
│   • agent-browser@vercel-labs (browser automation)            │
│                                                               │
│ Hooks:                                                        │
│   • pre-commit-test-gate      (run tests before commits)      │
│   • post-edit-tdd-reminder    (nudge toward test-first)       │
└───────────────────────────────────────────────────────────────┘

REFERENCE (added to CLAUDE.md):
┌───────────────────────────────────────────────────────────────┐
│ • Context Engineering — token reduction strategies            │
│ • Cole Medin's PIV Loop — Plan→Implement→Validate workflow    │
│ • Claude 4 Best Practices — prompting techniques              │
└───────────────────────────────────────────────────────────────┘

EXCLUDED (from top 10):
  • oh-my-claudecode — overlaps with superpowers
  • ralph — user prefers interactive over overnight autonomy
  • multiclaude — built for larger teams

═══════════════════════════════════════════════════════════════
[Apply] [Edit] [Explain choices]
```

### Edit Mode

```
INSTALL:
  [x] brave-search MCP
  [x] mem0 MCP
  [x] superpowers@obra
  [ ] agent-browser@vercel-labs    ← unchecked = skip
  [x] pre-commit-test-gate hook
  [ ] post-edit-tdd-reminder hook

  Add tool: __________________

REFERENCE:
  [x] Context Engineering
  [x] PIV Loop
  [ ] Claude 4 Best Practices      ← unchecked = skip

[Apply selected] [Back]
```

---

## Configuration Apply

### Order

MCPs → Plugins → CLAUDE.md → Hooks

(Some plugins depend on MCPs being configured first)

### Pre-Apply Snapshot

Before any changes, backup to `.claude/buckle-up-backup/`:
- `~/.claude.json` → `claude-json.backup`
- `.claude/settings.json` → `settings-json.backup`
- `CLAUDE.md` → `claude-md.backup` (if exists)

### MCP Installation

```
[1/6] MCP: brave-search
───────────────────────────────────────────────────────────────

Adding to ~/.claude.json:

  "brave-search": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@anthropic-ai/brave-search-mcp"],
    "env": {
      "BRAVE_API_KEY": "${BRAVE_API_KEY}"
    }
  }

Checking environment...
  ⚠ BRAVE_API_KEY not found

Options:
  [Guide me]     — Step-by-step setup instructions
  [Skip]         — Install this MCP later
  [I have it]    — Key is set, proceed with config

```

**JSON merge logic:**
1. Read existing `~/.claude.json` (or `{}` if missing)
2. Deep merge into `mcpServers` key
3. Preserve existing formatting where possible
4. Validate JSON before writing
5. On validation failure → abort, show error, offer rollback

### Plugin Installation

```
[3/6] Plugin: superpowers@obra
───────────────────────────────────────────────────────────────

To install, run:

  /plugin install superpowers@obra

Then restart Claude Code.

[Done] [Skip] [Help]
```

Note: Skills cannot directly invoke `/plugin install`. User must run the command.

### CLAUDE.md Configuration

```
[5/6] CLAUDE.md
───────────────────────────────────────────────────────────────

Existing CLAUDE.md detected (42 lines).

Options:
  [Merge]   — Append buckle-up section, keep existing content
  [Replace] — Use buckle-up template only
  [Skip]    — Don't modify CLAUDE.md
```

**Merge strategy:**
- Append `## Buckle-Up Configuration` section at end
- Never modify existing content
- If `## Buckle-Up Configuration` already exists, replace only that section

**Template:** (`templates/claude-md-section.md`)
```markdown
## Buckle-Up Configuration

Generated: {date}
Catalogue: {catalogue_path}

### Methodology
{methodology_references}

### Installed Tools
{installed_tools_list}

### Memory
{memory_notes_if_applicable}
```

### Hook Installation

```
[6/6] Hooks
───────────────────────────────────────────────────────────────

Installing to .claude/settings.json:

  PreToolUse (Bash containing "git commit"):
    → pre-commit-test-gate.sh

  PostToolUse (Edit or Write):
    → post-edit-tdd-reminder.sh

[Apply] [Skip]
```

**Hook installation steps:**
1. Copy hook scripts to `.claude/hooks/`
2. `chmod +x` each script
3. Merge hook config into `.claude/settings.json`
4. Verify scripts are executable

### Post-Apply Verification

After each install:
```
✓ brave-search MCP configured
✓ superpowers@obra installed (14 skills loaded)
✓ CLAUDE.md updated
✓ 2 hooks installed
```

### Failure Handling

```
✗ Failed to install mem0 MCP

Error: Invalid JSON in ~/.claude.json after merge

Options:
  [Retry]    — Try again
  [Skip]     — Continue without this component
  [Rollback] — Restore all backups, abort buckle-up
```

---

## State Management

**State file:** `.claude/buckle-up-state.json`

```json
{
  "version": "1.0",
  "lastRun": "2026-02-02T20:30:00Z",
  "cataloguePath": "/Users/razpetel/research-catalogue",
  "catalogueHash": "a3f2b1c4...",
  "interview": {
    "projectType": "web-app",
    "teamSize": "solo",
    "maturity": "production",
    "tokenConscious": 2,
    "autonomy": 3,
    "memory": "yes",
    "browser": "maybe",
    "complexity": "moderate",
    "keepTools": ["brave-search"],
    "notes": "Building a SaaS dashboard"
  },
  "scores": {
    "superpowers": 14,
    "ralph": 13,
    "mem0": 12,
    "agent-browser": 11
  },
  "selected": ["superpowers", "mem0", "agent-browser"],
  "methodologyRefs": ["context-engineering", "piv-loop"],
  "applied": {
    "mcps": ["brave-search", "mem0"],
    "plugins": ["superpowers@obra"],
    "claudeMd": true,
    "hooks": ["pre-commit-test-gate"]
  },
  "pending": {
    "plugins": ["agent-browser@vercel-labs"],
    "hooks": ["post-edit-tdd-reminder"]
  },
  "skipped": {
    "plugins": [],
    "mcps": [],
    "reasons": {
      "ralph": "User prefers interactive sessions"
    }
  }
}
```

### Re-run Modes

```
Previous buckle-up detected (2026-02-02).

Applied: 2 MCPs, 1 plugin, CLAUDE.md, 1 hook
Pending: 1 plugin, 1 hook (interrupted)

Options:
  [Resume]       — Apply pending items
  [Upgrade]      — Keep answers, check for new/updated tools
  [Re-interview] — Start fresh with new questions
  [Reset]        — Remove all buckle-up config
  [Status]       — Show current configuration
```

**Resume:** Continue from where interrupted. Apply pending items.

**Upgrade:**
1. Re-index catalogue if hash changed
2. Re-score with saved interview answers
3. Show diff: "New recommendations: X, Y. Changed scores: Z"
4. User picks what to add/change

**Reset:**
```
This will remove:
  • 2 MCPs from ~/.claude.json
  • 2 plugins
  • Buckle-up section from CLAUDE.md
  • 2 hooks from .claude/settings.json
  • .claude/buckle-up-state.json

Your code and other config untouched.

[Confirm reset] [Cancel]
```

### Catalogue Change Detection

On any run:
```
Catalogue updated since last run.
  • 3 new tools indexed
  • 2 reports have updates

[Re-score with new data] [Ignore for now]
```

---

## Hook Templates

### 1. pre-commit-test-gate

**Event:** `PreToolUse`
**Matcher:** `Bash` commands containing `git commit`
**Purpose:** Run tests before Claude commits code

**Config:**
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "command": ["PLUGIN_ROOT/hooks/pre-commit-test-gate.sh", "$TOOL_INPUT"]
    }]
  }
}
```

**Script:**
```bash
#!/usr/bin/env bash
# hooks/pre-commit-test-gate.sh

INPUT="$1"

# Only intercept git commit commands
if ! echo "$INPUT" | grep -q "git commit"; then
  exit 0
fi

echo "Running tests before commit..."

# Detect and run tests
if [ -f "package.json" ] && grep -q '"test"' package.json; then
  npm test || { echo "❌ Tests failed. Fix before committing."; exit 1; }
elif [ -f "pyproject.toml" ] || [ -f "pytest.ini" ]; then
  pytest || { echo "❌ Tests failed. Fix before committing."; exit 1; }
elif [ -f "Cargo.toml" ]; then
  cargo test || { echo "❌ Tests failed. Fix before committing."; exit 1; }
else
  echo "No test runner detected, skipping"
fi

exit 0
```

### 2. post-edit-tdd-reminder

**Event:** `PostToolUse`
**Matcher:** `Edit` or `Write`
**Purpose:** Nudge toward test-first when code is written

**Config:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "command": ["PLUGIN_ROOT/hooks/post-edit-tdd-reminder.sh", "$TOOL_INPUT"]
    }]
  }
}
```

**Script:**
```bash
#!/usr/bin/env bash
# hooks/post-edit-tdd-reminder.sh

FILE="$1"

# Skip if editing test files
if echo "$FILE" | grep -qE "(test_|_test\.|\.test\.|spec\.)"; then
  exit 0
fi

# Skip non-code files
if ! echo "$FILE" | grep -qE "\.(ts|js|tsx|jsx|py|go|rs|java|rb)$"; then
  exit 0
fi

echo "📝 Consider: Does this change have tests?"
exit 0
```

### 3. stop-session-log

**Event:** `Stop`
**Matcher:** (none - fires on all stops)
**Purpose:** Log session info for later review

**Config:**
```json
{
  "hooks": {
    "Stop": [{
      "command": ["PLUGIN_ROOT/hooks/stop-session-log.sh"]
    }]
  }
}
```

**Script:**
```bash
#!/usr/bin/env bash
# hooks/stop-session-log.sh

LOG_FILE=".claude/session-history.log"
mkdir -p "$(dirname "$LOG_FILE")"

{
  echo "---"
  echo "Session: $(date -Iseconds)"
  echo "Directory: $(pwd)"
  echo ""
} >> "$LOG_FILE"
```

---

## Plugin Structure

```
buckle-up/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Dev marketplace (testing)
│
├── skills/
│   └── buckle-up/
│       └── SKILL.md             # Main skill (<500 words)
│
├── references/
│   ├── scoring-matrix.md        # Dimensions, weights, formulas
│   ├── interview-questions.md   # Question bank with skip logic
│   └── tool-categories.md       # Category definitions
│
├── templates/
│   ├── claude-md-section.md     # CLAUDE.md section template
│   └── hooks/
│       ├── pre-commit-test-gate.sh
│       ├── post-edit-tdd-reminder.sh
│       └── stop-session-log.sh
│
├── scripts/
│   ├── index-catalogue.md       # Prompt for LLM indexing
│   └── selection-reasoning.md   # Prompt for LLM tool selection
│
└── README.md
```

### plugin.json

```json
{
  "name": "buckle-up",
  "version": "1.0.0",
  "description": "Project setup wizard using your research catalogue to configure optimal Claude Code tooling",
  "author": {
    "name": "razpetel"
  },
  "skills": ["./skills/buckle-up"]
}
```

### SKILL.md (under 500 words)

```yaml
---
name: buckle-up
description: Use when starting a new project or optimizing an existing one, when you have a research catalogue and need to configure Claude Code setup (plugins, MCPs, hooks, CLAUDE.md)
---
```

```markdown
# Buckle-Up

Configure optimal Claude Code tooling from your research catalogue.

## Flow

1. **Index** — Read catalogue, build tool index (cached)
2. **Interview** — 5-10 questions about project needs
3. **Score** — Rank tools across 5 weighted dimensions
4. **Research** — Optional web check on top 10 candidates
5. **Reason** — LLM selects minimal non-overlapping set
6. **Present** — Show full plan (Install / Reference / Excluded)
7. **Apply** — MCPs → Plugins → CLAUDE.md → Hooks (confirm each)

## Invocation

- `/buckle-up` — Auto-discover catalogue
- `/buckle-up /path/to/catalogue` — Explicit path

## Re-runs

Detects previous run. Offers: Resume | Upgrade | Re-interview | Reset | Status

## References

- Scoring: `references/scoring-matrix.md`
- Questions: `references/interview-questions.md`
- Categories: `references/tool-categories.md`
- Index prompt: `scripts/index-catalogue.md`
- Selection prompt: `scripts/selection-reasoning.md`
- Templates: `templates/`

## State

Saves to `.claude/buckle-up-state.json`:
- Interview answers (with crash recovery)
- Scores and selections
- Applied/pending/skipped items
- Catalogue hash for staleness

## Error Recovery

- Snapshots config before changes
- Tracks each applied item
- Offers rollback on failure
```

---

## README.md

```markdown
# buckle-up

Project setup wizard for Claude Code. Uses your research catalogue to configure the optimal toolset.

## Prerequisites

A research catalogue (like one created by [fomo-researcher](https://github.com/razpetel/fomo-researcher)) with:
- `catalogue.md` — Index of researched tools
- `catalogue/*.md` — Individual research reports

## Installation

```bash
/plugin marketplace add razpetel/buckle-up
/plugin install buckle-up@razpetel
```

Restart Claude Code.

## Usage

```bash
# Auto-discover catalogue
/buckle-up

# Explicit catalogue path
/buckle-up ~/my-research/catalogue.md
```

## What It Does

1. Indexes your research catalogue (cached)
2. Asks 5-10 questions about your project
3. Scores tools against your needs
4. Recommends minimal, non-overlapping toolset
5. Configures everything with your approval

## Re-runs

Already configured? Run `/buckle-up` again to:
- **Resume** — Finish interrupted setup
- **Upgrade** — Check for new tools in catalogue
- **Re-interview** — Start fresh
- **Reset** — Remove all buckle-up config

## What Gets Configured

- **MCPs** — Added to ~/.claude.json
- **Plugins** — Installation commands provided
- **CLAUDE.md** — Methodology references added
- **Hooks** — Test gates, TDD reminders

## State

Configuration saved to `.claude/buckle-up-state.json`. Backups at `.claude/buckle-up-backup/`.
```

---

## Test Plan

Before release, test these scenarios:

### Scenario 1: New Project
- Empty directory, no existing config
- Run `/buckle-up`
- Verify: prompts for catalogue, runs interview, applies config

### Scenario 2: Existing Config
- Project with existing CLAUDE.md, some MCPs
- Run `/buckle-up`
- Verify: detects existing, offers merge, handles conflicts

### Scenario 3: Re-run Resume
- Run buckle-up, interrupt mid-apply (Ctrl+C)
- Run `/buckle-up` again
- Verify: offers Resume, completes pending items

### Scenario 4: Re-run Upgrade
- Run buckle-up, complete
- Add new tool to catalogue
- Run `/buckle-up` again
- Verify: detects new tool, offers to add

### Scenario 5: Reset
- Configured project
- Run `/buckle-up`, choose Reset
- Verify: removes buckle-up config, preserves other config

### Scenario 6: Failure Rollback
- Simulate MCP install failure (invalid JSON)
- Verify: offers rollback, restores backups correctly

---

## Version Strategy

- Start at `1.0.0`
- Semantic versioning (major.minor.patch)
- Tag releases: `git tag v1.0.0`
- Update marketplace manifest for distribution

---

## Open Questions (Resolved)

| Question | Resolution |
|----------|------------|
| Where does index live? | Next to catalogue: `{catalogue-dir}/.toolshed-index.json` |
| How does interview UX work? | Conversational dialogue, not AskUserQuestion tool |
| Can skills invoke /plugin install? | No. Skill tells user to run command. |
| What if no catalogue? | Offer to create with fomo-researcher or point to existing |

---

## Implementation Deliverables

1. `SKILL.md` — Main skill file
2. `references/scoring-matrix.md` — Full dimension/weight definitions
3. `references/interview-questions.md` — Complete question bank with skip logic
4. `references/tool-categories.md` — Category definitions and tool mappings
5. `scripts/index-catalogue.md` — LLM prompt for indexing
6. `scripts/selection-reasoning.md` — LLM prompt for selection
7. `templates/claude-md-section.md` — CLAUDE.md template
8. `templates/hooks/*.sh` — All three hook scripts
9. `README.md` — User documentation
10. `plugin.json` — Plugin manifest
