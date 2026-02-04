# CLAUDE.md Writing Guidelines

Best practices for generating CLAUDE.md content, consolidated from research reports.

## Token Budget

CLAUDE.md loads on every session — treat tokens like prime real estate.

| Token-Consciousness | Target Words | Strategy |
|---------------------|--------------|----------|
| Level 3 (Very) | <500 | References only, minimal inline |
| Level 2 (Balanced) | 500-1500 | Core rules inline, details in refs |
| Level 1 (Feature-rich) | 1500-2000 | Full documentation with examples |

**Rule of thumb:** If you wouldn't pay rent for it, don't put it in CLAUDE.md.

---

## Thickness Hierarchy

From context-engineering research — push work toward deterministic execution:

```
THINNEST (lowest token cost)
├── Commands     → Orchestration triggers only
├── Agents       → Strategic direction, persona
├── Skills       → Detailed procedures (loaded on-demand)
├── Scripts/YAML → Zero-token deterministic execution
THICKEST (highest token cost)
└── Inline docs  → Loads every session
```

**Principle:** Reference files by path, don't embed content.

```markdown
<!-- BAD: Inline duplication -->
## TDD Workflow
1. Write failing test
2. Write minimal code to pass
3. Refactor
...200 more lines...

<!-- GOOD: Reference -->
## TDD Workflow
Use `/tdd` skill. See: superpowers:test-driven-development
```

---

## Explicit Instructions (Claude 4)

Claude 4 follows instructions precisely. "Suggest" means suggest, not implement.

| Less Effective | More Effective |
|----------------|----------------|
| "Consider running tests" | "Run tests before every commit" |
| "You might want to check..." | "Always check X before Y" |
| "Feel free to..." | "Do X" or "Do not do X" |

**For proactive behavior:**
```xml
<default_to_action>
Implement changes rather than suggesting. Proceed with likely intent.
</default_to_action>
```

**For conservative behavior:**
```xml
<confirm_before_action>
Propose changes and wait for approval before implementing.
</confirm_before_action>
```

---

## Context Motivation

Add "why" not just "what" — motivation improves compliance.

| Less Effective | More Effective |
|----------------|----------------|
| "Never use ellipses" | "Never use ellipses — TTS engines can't pronounce them" |
| "Run prettier before commits" | "Run prettier before commits to prevent CI failures" |
| "Keep functions under 50 lines" | "Keep functions under 50 lines for reviewability" |

---

## XML Tags

Claude was trained on XML-tagged prompts. Use them for structure:

```xml
<workflow>
  <step>Read the test file first</step>
  <step>Understand the expected behavior</step>
  <step>Write minimal implementation</step>
</workflow>

<rules>
  <rule priority="high">Never commit without tests</rule>
  <rule priority="medium">Prefer composition over inheritance</rule>
</rules>

<example>
Input: "Add user authentication"
Output: First, let me check existing auth patterns in the codebase...
</example>
```

---

## Tool Documentation Pattern

From everything-claude-code:

```markdown
### [Tool Name]

**Invoke:** `/command` or via MCP
**Purpose:** One sentence description
**When to use:** Specific triggers or scenarios

Example:
> "Use /tdd when implementing any feature or bugfix"
```

Keep it scannable — developers skim, they don't read.

---

## Hooks Documentation

```markdown
### Hooks Active

| Hook | Trigger | Purpose |
|------|---------|---------|
| test-gate | PreToolUse[Bash] | Run tests before git commit |
| tdd-reminder | PostToolUse[Edit] | Nudge toward test-first |
| session-log | Stop | Log session summary |
```

Don't explain how hooks work — just document what's active.

---

## Methodology References

Link to research, don't summarize:

```markdown
### Methodology

This project follows:
- **Context Engineering** — Clear at breakpoints, compact at 70%
- **PIV Loop** — Plan → Implement → Verify cycles
- **TDD** — Test-first development

See research catalogue for details.
```

---

## Anti-Patterns

### 1. Don't Duplicate Skill/Agent Content
```markdown
<!-- BAD -->
## Debugging Workflow
1. Reproduce the issue
2. Form hypothesis
3. Test hypothesis
...entire skill content...

<!-- GOOD -->
## Debugging
Use `superpowers:systematic-debugging` skill.
```

### 2. Don't List Every Feature
```markdown
<!-- BAD -->
## Brave Search MCP
- brave_web_search: Search the web
- brave_local_search: Search local businesses
- brave_news_search: Search news
- brave_image_search: Search images
...

<!-- GOOD -->
## Brave Search
Web search via MCP. See: mcp__brave-search
```

### 3. Don't Include Setup Instructions
Users already installed — document usage, not setup.

### 4. Don't Repeat Anthropic Defaults
Only document project-specific deviations.

---

## Section Template

```markdown
## Buckle-Up Configuration

> Generated: {date} | Catalogue: {path}

### Installed Tools

| Tool | Type | Purpose |
|------|------|---------|
{tools_table}

### Methodology

{brief_methodology_refs}

### Workflow

{autonomy_section_based_on_preference}

### Hooks

{hooks_table}

---
*Configured by buckle-up v{version}*
```

---

## Checklist Before Writing

- [ ] Word count matches token-consciousness level
- [ ] All installed tools documented (but not over-documented)
- [ ] Autonomy section matches user preference (1/2/3)
- [ ] References used instead of inline content where possible
- [ ] XML tags properly closed
- [ ] "Why" included for non-obvious rules
- [ ] No setup instructions (user already installed)
- [ ] No Anthropic default repetition
