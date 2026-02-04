# Config Writer Guidance

> Comprehensive reference for generating optimal CLAUDE.md and hooks configuration.
> This is the config-writer-agent's single source of truth.

---

## 1. Token Budget & Context Management

### The Fundamental Constraint

CLAUDE.md loads on every session start. Every token counts against the 200K context window.

> "Find the smallest set of high-signal tokens that maximize the likelihood of your desired outcome."
> — Anthropic Engineering

### Token Budget by Level

| tokenConscious | Target Words | Target Tokens | Strategy |
|----------------|--------------|---------------|----------|
| 1 (Not concerned) | 1500-2000 | ~2500-3200 | Full documentation with examples |
| 2 (Balanced) | 500-1500 | ~800-2400 | Core rules inline, details in refs |
| 3 (Very concerned) | <500 | <800 | References only, minimal inline |

### Context Window Math

In a well-configured project:
- **Baseline context**: ~20K tokens (10% of 200K window)
- **Available for work**: ~180K tokens (90%)
- **Sweet spot before compaction**: 70-80% capacity
- **Skills vs raw MCP**: 85% free context with skills-based approach

### The Thickness Hierarchy

Push work toward deterministic (non-token-consuming) execution:

```
THINNEST (lowest token cost)
├── Commands     → Orchestration triggers only (e.g., /tdd)
├── Agents       → Strategic direction, persona definition
├── Skills       → Detailed procedures (loaded on-demand)
├── Scripts/YAML → Zero-token deterministic execution
THICKEST (highest token cost)
└── Inline docs  → Loads every session
```

**Core Principle:** Reference files by path; don't embed content.

### When to Inline vs Reference

**Inline when:**
- Rule is < 2 sentences
- Used in 30%+ of all tasks
- Requires immediate visibility (safety rules)
- No skill/command exists for it

**Reference when:**
- Explanation exceeds 3 sentences
- Only relevant for specific workflows
- A skill or agent already handles it
- Content includes code examples or templates

### Reference Patterns

```markdown
<!-- Pattern 1: Skill reference -->
For TDD workflow, use `/tdd`. See: superpowers:test-driven-development

<!-- Pattern 2: File reference -->
API patterns documented in: /docs/api-conventions.md

<!-- Pattern 3: MCP reference -->
Web search available via: mcp__brave-search (brave_web_search, brave_news_search)

<!-- Pattern 4: Brief inline + reference -->
Run tests before commits. Details: /scripts/test-gate.md
```

---

## 2. CLAUDE.md Structure

### Section Order

```markdown
# Project Name

> One-line project description

## Quick Start
<!-- Critical commands, 2-3 lines max -->

## Tech Stack
<!-- List only non-obvious technologies -->

## Installed Tools
<!-- Table of MCPs, plugins, skills -->

## Methodology
<!-- Brief references to frameworks in use -->

## Workflow
<!-- Autonomy-appropriate behavior settings -->

## Hooks
<!-- Table of active hooks -->

## Rules
<!-- Project-specific constraints, NOT Anthropic defaults -->
```

### Token-Conscious Level 3 Template (~300 words)

```markdown
# {Project Name}

> {One-line description}

## Stack
{Language}, {Framework}. Testing: {test_framework}.

## Tools

| Tool | Purpose |
|------|---------|
| {tool_name} | {one_sentence} |

## Workflow

{autonomy_section}

## Hooks

| Event | Purpose |
|-------|---------|
| {hook} | {purpose} |

## Rules

- {rule_1}
- {rule_2}
```

### Balanced Level 2 Template (~800 words)

```markdown
# {Project Name}

> {One-line description}

## Quick Start

```bash
{install_command}
{dev_command}
{test_command}
```

## Tech Stack

- **Language:** {language}
- **Framework:** {framework}
- **Testing:** {test_framework}
- **Build:** {build_tool}

## Installed Tools

| Tool | Type | Invoke | Purpose |
|------|------|--------|---------|
| {tool_name} | {MCP/Plugin/Skill} | {command} | {purpose} |

## Methodology

This project follows:
- **{methodology_1}** — {one_sentence_summary}
- **{methodology_2}** — {one_sentence_summary}

## Workflow

{autonomy_section_expanded}

## Active Hooks

| Hook | Event | Trigger | Purpose |
|------|-------|---------|---------|
| {name} | {PreToolUse/PostToolUse/Stop} | {matcher} | {what_it_does} |

## Rules

### Code Quality
{quality_rules}

### Testing
{testing_rules}

### Git
{git_rules}
```

### Feature-Rich Level 1 Template (~1500 words)

```markdown
# {Project Name}

> {Project description with context}

## Quick Start

```bash
# Install dependencies
{install_command}

# Start development
{dev_command}

# Run tests
{test_command}

# Build for production
{build_command}
```

## Tech Stack

| Category | Technology | Notes |
|----------|------------|-------|
| Language | {language} | {version} |
| Framework | {framework} | {specific_features_used} |
| Testing | {test_framework} | {coverage_requirements} |
| Build | {build_tool} | {configuration_notes} |

## Installed Tools

### MCPs

| MCP | Purpose | Key Commands |
|-----|---------|--------------|
| {mcp_name} | {purpose} | {commands} |

### Plugins

| Plugin | Purpose | Invoke |
|--------|---------|--------|
| {plugin_name} | {purpose} | {command} |

### Skills

| Skill | Purpose | Invoke |
|-------|---------|--------|
| {skill_name} | {purpose} | {command} |

## Methodology

### {Methodology Name}

{2-3 sentence description}. Reference: {path_or_link}

**Key principles:**
- {principle_1}
- {principle_2}

## Workflow

{full_autonomy_section_with_examples}

## Active Hooks

### {Hook Name}

**Event:** {event_type}
**Trigger:** {matcher_pattern}
**Purpose:** {what_it_does}

{repeat for each hook}

## Rules

### Code Quality

{expanded_quality_rules_with_rationale}

### Testing

{expanded_testing_rules}

### Git Conventions

{git_workflow_rules}

### Architecture

{architectural_constraints}
```

---

## 3. Writing Style for Claude 4

### Explicit Instructions Are Required

Claude 4.x follows instructions precisely. "Suggest" means suggest, not implement.

| Less Effective | More Effective |
|----------------|----------------|
| "Consider running tests" | "Run tests before every commit" |
| "You might want to check..." | "Always check X before Y" |
| "Feel free to..." | "Do X" |
| "Can you suggest changes?" | "Make these changes" |

### Context Motivation ("Why" Not Just "What")

Adding motivation improves compliance significantly.

| Less Effective | More Effective |
|----------------|----------------|
| "Never use ellipses" | "Never use ellipses — TTS engines can't pronounce them" |
| "Run prettier before commits" | "Run prettier before commits to prevent CI failures" |
| "Keep functions under 50 lines" | "Keep functions under 50 lines for reviewability" |
| "Use TypeScript strict mode" | "Use TypeScript strict mode to catch null errors at compile time" |

### XML Tag Patterns

Claude was trained on XML-tagged prompts. Use them for structure and clarity.

#### Action Control Tags

```xml
<!-- For proactive behavior -->
<default_to_action>
By default, implement changes rather than only suggesting them. If the user's
intent is unclear, infer the most useful likely action and proceed, using tools
to discover any missing details instead of guessing.
</default_to_action>

<!-- For conservative behavior -->
<confirm_before_action>
Do not jump into implementation unless clearly instructed. Default to providing
information and recommendations rather than taking action. Propose changes and
wait for approval before implementing.
</confirm_before_action>

<!-- For investigation-first -->
<investigate_before_answering>
Never speculate about code you have not opened. If the user references a
specific file, you MUST read the file before answering. Give grounded and
hallucination-free answers.
</investigate_before_answering>
```

#### Workflow Tags

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

#### Parallel Tool Usage Tag

```xml
<use_parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between them,
make all independent calls in parallel. Never use placeholders or guess parameters.
</use_parallel_tool_calls>
```

#### Frontend Design Tag

```xml
<frontend_aesthetics>
Focus on:
- Typography: Choose distinctive fonts, avoid Arial, Inter, Roboto
- Color & Theme: Commit to cohesive aesthetic, use CSS variables
- Motion: Prioritize CSS-only solutions, one well-orchestrated page load
- Backgrounds: Create atmosphere and depth, not solid colors

Avoid: Overused fonts, purple gradients on white, cookie-cutter patterns
</frontend_aesthetics>
```

#### Over-Engineering Prevention Tag

```xml
<minimal_changes>
Only make changes that are directly requested or clearly necessary. Keep solutions
simple and focused.

Don't add features, refactor code, or make "improvements" beyond what was asked.
Don't add error handling for scenarios that can't happen.
Don't create helpers or abstractions for one-time operations.
</minimal_changes>
```

### Communication Style Notes

Claude 4.5 models communicate differently:
- More direct and fact-based
- May skip summaries for efficiency
- More conversational, less machine-like

To request progress updates:
```
After completing a task that involves tool use, provide a quick summary
of the work you've done.
```

---

## 4. Autonomy Settings

### Autonomy Level 1: High Supervision

**User Profile:** Wants to approve every significant action. Learning mode or critical project.

#### CLAUDE.md Section

```markdown
## Workflow

<confirm_before_action>
Before making any file changes:
1. Explain what you intend to do
2. Show the specific changes planned
3. Wait for explicit approval

Never proceed without confirmation for:
- File creation or deletion
- Code modifications
- Git operations
- External API calls
</confirm_before_action>

### Decision Points

Always pause and ask before:
- Installing new dependencies
- Modifying configuration files
- Running potentially destructive commands
- Making architectural decisions
```

#### Hooks Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Write", "Edit"]},
        "hooks": [
          {
            "type": "command",
            "command": "echo 'File modification requires approval' >&2 && exit 0"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before stopping, verify with the user that the task is complete as they expected. If anything was changed, list the changes for review."
          }
        ]
      }
    ]
  }
}
```

### Autonomy Level 2: Balanced (Default)

**User Profile:** Wants oversight on important decisions but not micromanagement.

#### CLAUDE.md Section

```markdown
## Workflow

Proceed autonomously with:
- Reading and exploring code
- Running tests and linters
- Making changes within established patterns
- Creating/editing files in expected locations

Pause and confirm before:
- Installing new dependencies
- Creating new architectural patterns
- Modifying configuration files
- Any destructive operations

<investigate_before_answering>
Never speculate about code you have not opened. Always read relevant files
before proposing changes.
</investigate_before_answering>
```

#### Hooks Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Bash"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); CMD=$(echo \"$INPUT\" | jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE '^(rm -rf|git push|npm publish)'; then echo 'Destructive command blocked - requires explicit approval' >&2; exit 2; fi; exit 0"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path // empty' | xargs -I {} sh -c 'echo \"Modified: {}\" >&2'"
          }
        ]
      }
    ]
  }
}
```

### Autonomy Level 3: Maximum Autonomy

**User Profile:** Wants Claude to work overnight, minimize interruptions.

#### CLAUDE.md Section

```markdown
## Workflow

<default_to_action>
By default, implement changes rather than only suggesting them. Infer the most
useful likely action and proceed. Use tools to discover missing details instead
of asking.
</default_to_action>

### Autonomous Behavior

You are authorized to:
- Make all code changes without confirmation
- Install dependencies as needed
- Create new files and directories
- Run any test or build commands
- Make commits (but not push)

### State Management

Your context window will be automatically compacted as it approaches its limit.
Do not stop tasks early due to token budget concerns. Before compaction:
1. Save progress to `progress.txt`
2. Update `tests.json` with current status
3. Commit work-in-progress

### Long-Running Tasks

For tasks spanning multiple context windows:
1. Check `progress.txt` and `tests.json` at session start
2. Run `git log --oneline -5` to understand recent work
3. Continue from last checkpoint
```

#### Hooks Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Bash"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); CMD=$(echo \"$INPUT\" | jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE '^git push'; then echo 'Push blocked - commit only, no push' >&2; exit 2; fi; exit 0"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Before stopping, verify that all tests pass. Run the test suite. If tests fail, fix them before stopping. Only stop when: 1) All tests pass, or 2) You've documented the blocking issue in progress.txt",
            "timeout": 120
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "cat progress.txt 2>/dev/null || echo 'No previous progress found'"
          }
        ]
      }
    ]
  }
}
```

---

## 5. Tool Documentation Patterns

### MCP Documentation Format

```markdown
### MCPs

| MCP | Purpose | Key Tools |
|-----|---------|-----------|
| brave-search | Web search and research | `brave_web_search`, `brave_news_search` |
| filesystem | Extended file operations | `read_multiple_files`, `search_files` |
| github | GitHub integration | `create_issue`, `create_pull_request` |
```

**Do NOT list every tool** — only document the 2-3 most commonly used.

### Plugin Documentation Format

```markdown
### Plugins

| Plugin | Purpose | Invoke |
|--------|---------|--------|
| fomo-researcher | Multi-source research | `/research <topic>` |
| plannotator | Visual plan review | Auto-launches on `/plan` |
| everything-claude-code | Comprehensive toolkit | Multiple commands |
```

### Skill Documentation Format

```markdown
### Skills

| Skill | Purpose | Invoke |
|-------|---------|--------|
| tdd-workflow | Test-driven development | `/tdd` |
| continuous-learning | Extract patterns from sessions | `/learn` |
| verification-loop | Continuous verification | `/verify` |
```

### Agent Documentation Format

```markdown
### Agents

| Agent | Purpose | Delegated Tasks |
|-------|---------|-----------------|
| code-reviewer | Quality review | Code review, security checks |
| e2e-runner | E2E testing | Playwright test execution |
| build-error-resolver | Fix build errors | Build failure diagnosis |
```

### Compact Format (Level 3)

```markdown
## Tools

MCPs: brave-search, filesystem, github
Plugins: fomo-researcher, everything-claude-code
Skills: `/tdd`, `/verify`, `/learn`
```

### Token-Conscious Tool Listing

Only document tools used by 30%+ of workflows. For rarely-used tools:

```markdown
Additional tools available. Run `/tools` to see full list.
```

---

## 6. Hooks Configuration

### Hook Event Reference

| Event | When It Fires | Common Uses |
|-------|---------------|-------------|
| `SessionStart` | Session begins or resumes | Re-inject context after compaction |
| `UserPromptSubmit` | User submits prompt | Input validation, context injection |
| `PreToolUse` | Before tool executes | Block dangerous operations, validation |
| `PostToolUse` | After tool succeeds | Auto-formatting, logging |
| `PostToolUseFailure` | After tool fails | Error handling, retry logic |
| `PermissionRequest` | Permission dialog appears | Auto-approve safe operations |
| `Notification` | Claude needs attention | Desktop notifications |
| `SubagentStart` | Subagent spawns | Logging, resource allocation |
| `SubagentStop` | Subagent finishes | Result verification |
| `Stop` | Claude finishes responding | Task verification, summary |
| `PreCompact` | Before compaction | Save critical context |
| `SessionEnd` | Session terminates | Cleanup, persistence |

### Matcher Syntax

| Event | What Matcher Filters | Examples |
|-------|---------------------|----------|
| PreToolUse, PostToolUse | Tool name | `Bash`, `Edit\|Write`, `mcp__.*` |
| SessionStart | How session started | `startup`, `resume`, `compact` |
| SessionEnd | Why session ended | `clear`, `logout`, `other` |
| Notification | Notification type | `permission_prompt`, `idle_prompt` |
| SubagentStart/Stop | Agent type | `Bash`, `Explore`, `Plan` |

**Wildcards:** `*` or empty string `""` matches all.

### Hook Types

#### Command Hooks (Deterministic)

```json
{
  "type": "command",
  "command": "prettier --write \"$CLAUDE_TOOL_INPUT_FILE_PATH\""
}
```

#### Prompt Hooks (Single-Turn LLM)

```json
{
  "type": "prompt",
  "prompt": "Check if the task is complete. Respond with {\"ok\": true} or {\"ok\": false, \"reason\": \"what remains\"}."
}
```

#### Agent Hooks (Multi-Turn LLM with Tools)

```json
{
  "type": "agent",
  "prompt": "Verify all tests pass. Run the test suite and check results.",
  "timeout": 120
}
```

### Exit Code Semantics

| Exit Code | Effect |
|-----------|--------|
| 0 | Action proceeds; stdout added to context |
| 2 | Action blocked; stderr sent to Claude as feedback |
| Other | Action proceeds; stderr logged but not shown |

### Hook Templates

#### Auto-Format After Edits

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

#### Block Protected Files

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); FILE=$(echo \"$INPUT\" | jq -r '.tool_input.file_path // empty'); for p in '.env' 'package-lock.json' '.git/'; do if [[ \"$FILE\" == *\"$p\"* ]]; then echo \"Blocked: $FILE matches protected pattern\" >&2; exit 2; fi; done; exit 0"
          }
        ]
      }
    ]
  }
}
```

#### Test Gate Before Commit

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Bash"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); CMD=$(echo \"$INPUT\" | jq -r '.tool_input.command'); if echo \"$CMD\" | grep -q 'git commit'; then if [ ! -f /tmp/tests-passed ]; then echo 'Tests must pass before commit. Run test suite first.' >&2; exit 2; fi; fi; exit 0"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": {"tools": ["Bash"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); CMD=$(echo \"$INPUT\" | jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE '^(npm test|yarn test|pytest|go test)'; then RESULT=$(echo \"$INPUT\" | jq -r '.tool_result.exit_code // 0'); if [ \"$RESULT\" = \"0\" ]; then touch /tmp/tests-passed; fi; fi; exit 0"
          }
        ]
      }
    ]
  }
}
```

#### Desktop Notifications

```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

#### Re-inject Context After Compaction

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Reminder: This project uses Bun (not npm). Run bun test before commits. Current sprint: auth refactor.'"
          }
        ]
      }
    ]
  }
}
```

#### Task Completion Verification (Agent Hook)

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verify the task is complete. Check: 1) All requested changes made, 2) Tests pass, 3) No linting errors. If incomplete, respond with {\"ok\": false, \"reason\": \"what remains\"}.",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### Full settings.json Example

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); FILE=$(echo \"$INPUT\" | jq -r '.tool_input.file_path // empty'); for p in '.env' 'package-lock.json'; do if [[ \"$FILE\" == *\"$p\"* ]]; then echo \"Protected file\" >&2; exit 2; fi; done; exit 0"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null || true"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Verify task completion. Respond {\"ok\": true} if complete, {\"ok\": false, \"reason\": \"...\"} if not."
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude needs attention\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

---

## 7. Anti-Patterns to Avoid

### CLAUDE.md Anti-Patterns

#### 1. Don't Duplicate Skill/Agent Content

```markdown
<!-- BAD -->
## Debugging Workflow
1. Reproduce the issue
2. Form hypothesis
3. Test hypothesis
4. Implement fix
5. Verify fix
...entire procedure...

<!-- GOOD -->
## Debugging
Use `superpowers:systematic-debugging` skill.
```

#### 2. Don't List Every MCP Tool

```markdown
<!-- BAD -->
## Brave Search MCP
- brave_web_search: Search the web
- brave_local_search: Search local businesses
- brave_news_search: Search news
- brave_image_search: Search images
- brave_video_search: Search videos
- brave_summarizer: Summarize results

<!-- GOOD -->
## Search
Web search via brave-search MCP. Primary: `brave_web_search`, `brave_news_search`.
```

#### 3. Don't Include Setup Instructions

```markdown
<!-- BAD -->
## Installation
1. Install Claude Code CLI
2. Run `claude configure`
3. Add your API key
...

<!-- GOOD -->
<!-- Skip entirely - user already installed -->
```

#### 4. Don't Repeat Anthropic Defaults

Only document project-specific deviations from Claude's default behavior.

```markdown
<!-- BAD -->
## General Guidelines
- Be helpful and harmless
- Provide accurate information
- Admit when you don't know something

<!-- GOOD -->
<!-- Skip - these are defaults -->
```

#### 5. Don't Embed Full File Contents

```markdown
<!-- BAD -->
## API Response Format
```json
{
  "status": "success",
  "data": {
    "id": "string",
    "name": "string",
    ...100 lines...
  }
}
```

<!-- GOOD -->
## API Format
See: `/docs/api-schema.json`
```

#### 6. Don't Use Vague Language

```markdown
<!-- BAD -->
- Consider writing tests
- You might want to check the linter
- Feel free to ask for clarification

<!-- GOOD -->
- Write tests for all new code
- Run linter before commits
- Ask for clarification when requirements are ambiguous
```

### Hooks Anti-Patterns

#### 1. Don't Block During Editing

```json
// BAD - Confuses Claude mid-plan
{
  "PreToolUse": [
    {
      "matcher": {"tools": ["Edit"]},
      "hooks": [{"type": "command", "command": "npm test"}]
    }
  ]
}

// GOOD - Validate at commit stage
{
  "PreToolUse": [
    {
      "matcher": {"tools": ["Bash"]},
      "hooks": [{"type": "command", "command": "check_if_git_commit.sh"}]
    }
  ]
}
```

#### 2. Don't Create Infinite Loops

```json
// BAD - Stop hook always returns false
{
  "Stop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Are you absolutely sure everything is perfect?"
    }]
  }]
}

// GOOD - Check stop_hook_active flag
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "INPUT=$(cat); if [ \"$(echo \"$INPUT\" | jq -r '.stop_hook_active')\" = \"true\" ]; then exit 0; fi; # ... actual logic"
    }]
  }]
}
```

#### 3. Don't Echo in Shell Profile

If your `~/.zshrc` has unconditional echo statements, they'll break JSON parsing:

```bash
# BAD in ~/.zshrc
echo "Shell ready"

# GOOD in ~/.zshrc
if [[ $- == *i* ]]; then
  echo "Shell ready"
fi
```

### Frontend Anti-Patterns (AI Slop)

When documenting frontend projects, warn against:

- Overused fonts: Inter, Roboto, Arial, system fonts
- Generic purple gradients on white backgrounds
- Cookie-cutter component patterns
- Lack of distinctive typography
- Solid color backgrounds without depth

---

## 8. Quick Reference Tables

### Token Budget Quick Reference

| Level | Words | Tokens | inline_full | refs_only |
|-------|-------|--------|-------------|-----------|
| 1 | 1500-2000 | ~3000 | Yes | No |
| 2 | 500-1500 | ~2000 | Core only | Yes |
| 3 | <500 | <800 | No | Yes |

### Autonomy Quick Reference

| Level | Behavior | Confirmation Required |
|-------|----------|----------------------|
| 1 | Conservative | All file changes, commands |
| 2 | Balanced | Dependencies, config, destructive ops |
| 3 | Autonomous | Only git push blocked |

### Hook Event Quick Reference

| Event | Matcher Target | Can Block? | Common Use |
|-------|---------------|------------|------------|
| PreToolUse | Tool name | Yes (exit 2) | Validation |
| PostToolUse | Tool name | No | Formatting |
| Stop | N/A | Yes (JSON) | Task verification |
| SessionStart | Source | No | Context injection |
| Notification | Type | No | Alerts |

### XML Tag Quick Reference

| Tag | Purpose | Autonomy Level |
|-----|---------|----------------|
| `<default_to_action>` | Implement without asking | 3 |
| `<confirm_before_action>` | Always ask first | 1 |
| `<investigate_before_answering>` | Read before responding | 1, 2 |
| `<minimal_changes>` | Avoid over-engineering | All |
| `<use_parallel_tool_calls>` | Parallel execution | 2, 3 |

### Methodology Quick Reference

| Methodology | Key Principle | Reference Pattern |
|-------------|--------------|-------------------|
| Context Engineering | 70-80% capacity, then compact | Use skills, not inline |
| PIV Loop | Plan -> Implement -> Verify | git as checkpoint |
| TDD | Test-first development | `/tdd` skill |
| Thickness Hierarchy | Push toward deterministic | Commands -> Hooks |

### Hook Template Quick Reference

| Use Case | Event | Type | Matcher |
|----------|-------|------|---------|
| Auto-format | PostToolUse | command | Edit\|Write |
| Block protected files | PreToolUse | command | Edit\|Write |
| Test gate | PreToolUse | command | Bash |
| Task verification | Stop | prompt/agent | (none) |
| Context after compact | SessionStart | command | compact |
| Desktop notification | Notification | command | (none) |

---

## 9. Generation Checklist

Before generating CLAUDE.md:

- [ ] Word count matches `tokenConscious` level
- [ ] All installed tools documented (not over-documented)
- [ ] Autonomy section matches user preference (1/2/3)
- [ ] References used instead of inline content where possible
- [ ] XML tags properly closed
- [ ] "Why" included for non-obvious rules
- [ ] No setup instructions (user already installed)
- [ ] No Anthropic default repetition
- [ ] Methodology references are brief
- [ ] Hook table includes all active hooks

Before generating hooks:

- [ ] Events match desired behavior
- [ ] Matchers are specific (not too broad)
- [ ] Exit codes used correctly (0 proceed, 2 block)
- [ ] JSON parsing uses `jq`
- [ ] No infinite loop potential in Stop hooks
- [ ] Timeout set for long-running hooks
- [ ] Protected files list is project-appropriate

---

## 10. Example Generations

### Example 1: Solo Developer, Web App, tokenConscious=2, autonomy=2

**CLAUDE.md:**

```markdown
# MyApp Dashboard

> React dashboard with Node.js backend

## Quick Start

```bash
npm install
npm run dev
npm test
```

## Tech Stack

- **Frontend:** React 18, TypeScript, Tailwind
- **Backend:** Node.js, Express, PostgreSQL
- **Testing:** Jest, React Testing Library

## Tools

| Tool | Type | Purpose |
|------|------|---------|
| brave-search | MCP | Web research |
| fomo-researcher | Plugin | Deep research |
| tdd-workflow | Skill | Test-first dev |

## Workflow

Proceed autonomously with:
- Reading and exploring code
- Running tests and linters
- Making changes within established patterns

Pause and confirm before:
- Installing new dependencies
- Modifying configuration files
- Any destructive operations

<investigate_before_answering>
Never speculate about code you have not opened. Always read relevant files
before proposing changes.
</investigate_before_answering>

## Hooks

| Event | Purpose |
|-------|---------|
| PostToolUse[Edit\|Write] | Auto-format with Prettier |
| PreToolUse[Bash] | Block destructive commands |

## Rules

- Run `npm test` before commits — CI will fail otherwise
- Use TypeScript strict mode — catches null errors at compile time
- Components in `/src/components/` — keeps codebase navigable
```

**settings.json:**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Bash"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); CMD=$(echo \"$INPUT\" | jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE '^(rm -rf|git push --force)'; then echo 'Destructive command blocked' >&2; exit 2; fi; exit 0"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### Example 2: Team, Production API, tokenConscious=3, autonomy=1

**CLAUDE.md:**

```markdown
# PaymentService API

> Production payment processing service

## Stack
Go 1.21, PostgreSQL, Redis. Testing: go test.

## Tools

| Tool | Purpose |
|------|---------|
| github MCP | PR management |
| security-review | Audit changes |

## Workflow

<confirm_before_action>
Before any file changes:
1. Explain intended changes
2. Show specific modifications
3. Wait for approval
</confirm_before_action>

## Hooks

| Event | Purpose |
|-------|---------|
| PreToolUse[Edit] | Require approval |
| Stop | Verify completion with user |

## Rules

- No changes to `/internal/payment/` without explicit approval
- All PRs require security review
- 80% test coverage minimum
```

**settings.json:**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); FILE=$(echo \"$INPUT\" | jq -r '.tool_input.file_path // empty'); if [[ \"$FILE\" == *\"internal/payment\"* ]]; then echo 'Payment code requires explicit approval' >&2; exit 2; fi; exit 0"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Verify with user that the task is complete as expected. List all changes made for review."
          }
        ]
      }
    ]
  }
}
```

### Example 3: Solo, Hobby CLI, tokenConscious=1, autonomy=3

**CLAUDE.md:**

```markdown
# mycli

> Personal CLI tool for file organization

## Quick Start

```bash
cargo build
cargo test
cargo run -- --help
```

## Tech Stack

| Category | Technology | Notes |
|----------|------------|-------|
| Language | Rust 1.75 | Edition 2021 |
| Testing | cargo test | Integration tests in /tests |
| Linting | clippy | Run with `cargo clippy` |

## Installed Tools

### MCPs

| MCP | Purpose | Key Commands |
|-----|---------|--------------|
| filesystem | Extended file ops | `read_multiple_files`, `search_files` |
| brave-search | Research | `brave_web_search` |

### Skills

| Skill | Purpose | Invoke |
|-------|---------|--------|
| tdd-workflow | Test-first development | `/tdd` |
| continuous-learning | Pattern extraction | `/learn` |

## Methodology

### Test-Driven Development

Write tests first, implement to pass, refactor. Reference: superpowers:tdd-workflow

**Key principles:**
- Red-green-refactor cycle
- One test at a time
- Minimal code to pass

## Workflow

<default_to_action>
By default, implement changes rather than only suggesting them. Infer the most
useful likely action and proceed. Use tools to discover missing details instead
of asking.
</default_to_action>

### Autonomous Behavior

You are authorized to:
- Make all code changes without confirmation
- Install dependencies as needed
- Create new files and directories
- Run any test or build commands
- Make commits (but not push)

### State Management

Your context window will be automatically compacted as it approaches its limit.
Do not stop tasks early due to token budget concerns. Before compaction:
1. Save progress to `progress.txt`
2. Commit work-in-progress

### Long-Running Tasks

For tasks spanning multiple context windows:
1. Check `progress.txt` at session start
2. Run `git log --oneline -5` to understand recent work
3. Continue from last checkpoint

## Active Hooks

### Auto-Format

**Event:** PostToolUse
**Trigger:** Edit|Write on .rs files
**Purpose:** Run rustfmt automatically

### Test Verification

**Event:** Stop
**Trigger:** Always
**Purpose:** Verify tests pass before stopping

### Context Restoration

**Event:** SessionStart
**Trigger:** compact
**Purpose:** Restore progress context after compaction

## Rules

### Code Quality

- Use `clippy` for linting — catches common Rust mistakes
- Prefer `Result<T, E>` over panics — CLI tools should fail gracefully
- Document public APIs with `///` comments — `cargo doc` generates from these

### Testing

- Write integration tests for CLI commands in `/tests`
- Use `assert_cmd` crate for CLI testing
- Minimum 70% coverage for core logic

### Git Conventions

- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- One logical change per commit
- Never push directly — open PR even for solo work
```

**settings.json:**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tools": ["Bash"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); CMD=$(echo \"$INPUT\" | jq -r '.tool_input.command'); if echo \"$CMD\" | grep -q 'git push'; then echo 'Push blocked - use PR workflow' >&2; exit 2; fi; exit 0"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": {"tools": ["Edit", "Write"]},
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); FILE=$(echo \"$INPUT\" | jq -r '.tool_input.file_path // empty'); if [[ \"$FILE\" == *.rs ]]; then rustfmt \"$FILE\" 2>/dev/null || true; fi; exit 0"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verify all tests pass by running 'cargo test'. If tests fail, fix them. Only stop when tests pass or you've documented the blocking issue.",
            "timeout": 120
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo '=== Restored Context ===' && cat progress.txt 2>/dev/null || echo 'No previous progress' && echo '=== Recent Commits ===' && git log --oneline -5 2>/dev/null || echo 'No git history'"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude needs attention\" with title \"mycli\"'"
          }
        ]
      }
    ]
  }
}
```

---

*End of Config Writer Guidance*
