# Verification Rules

Rules for validating buckle-up configuration across four dimensions.

---

## 1. Operational Checks

Verify that configured tools actually work.

### MCP Verification

```bash
# Read ~/.claude.json
# For each MCP in state.installed.mcps:
jq -e ".mcpServers.\"${MCP_NAME}\"" ~/.claude.json > /dev/null
```

**Check required env vars:**
```bash
# From state.researchResults[tool].requiredEnvVars
for var in "${REQUIRED_VARS[@]}"; do
  test -n "${!var}" || echo "Missing: $var"
done
```

### Plugin Verification

```bash
# Plugins are user-installed via commands
# Verify by checking if plugin appears in installed list
# (Manual verification - ask user to confirm)
```

### Hook Verification

```bash
# Read .claude/settings.json
# For each hook with file-based command:
test -f "${HOOK_PATH}" && test -x "${HOOK_PATH}"

# For inline bash commands:
bash -n <<< "${HOOK_COMMAND}"
```

---

## 2. Coherent Checks

Verify that configuration components work together without conflicts.

### No Duplicate MCPs

```bash
# ~/.claude.json mcpServers keys must be unique
jq '.mcpServers | keys | group_by(.) | map(select(length > 1))' ~/.claude.json
# Should return []
```

### No Hook Conflicts

Check `.claude/settings.json` for:
- Same matcher with different blocking behaviors
- Overlapping matchers that could cause race conditions

```
PreToolUse[Bash] + PreToolUse[Bash] with different commands = WARN
PreToolUse[*] + PreToolUse[Bash] = OK (specific overrides general)
```

### Reference Integrity

Every tool mentioned in CLAUDE.md must exist in `state.installed`:

```bash
# Extract tool names from CLAUDE.md "Installed Tools" table
# Compare against state.installed.mcps + state.installed.plugins
# Flag orphan references
```

### No Circular Dependencies

Hooks should not trigger each other in loops:
- PostToolUse[Write] that writes → triggers itself

---

## 3. Well-Defined Checks

Verify configuration is complete and valid.

### JSON Validity

```bash
jq . ~/.claude.json > /dev/null 2>&1 || echo "Invalid: ~/.claude.json"
jq . .claude/settings.json > /dev/null 2>&1 || echo "Invalid: settings.json"
jq . .claude/buckle-up-state.json > /dev/null 2>&1 || echo "Invalid: state.json"
```

### Hook Syntax

```bash
# For file-based hooks:
bash -n "${HOOK_FILE}"

# For inline hooks:
bash -n <<< "${INLINE_COMMAND}"
```

### State Completeness

State file must have:
```json
{
  "version": "required",
  "phase": "required",
  "interview": "required",
  "approved": "required",
  "installed": "required",
  "researchResults": "optional"
}
```

### CLAUDE.md Sections

Buckle-up section must have:
- `### Installed Tools` table
- `### Methodology` or equivalent
- Generated timestamp

---

## 4. Spec Matching Checks

Verify output matches what was planned from interview.

### Tool Coverage

```
state.installed.mcps + state.installed.plugins
  ==
state.approved tools
```

All approved tools should be in installed. Flag:
- Missing: approved but not installed
- Extra: installed but not approved

### Token Budget

| tokenConscious | Max Words |
|----------------|-----------|
| 3 (very) | 500 |
| 2 (balanced) | 1500 |
| 1 (feature-rich) | 2500 |

```bash
# Count words in buckle-up section of CLAUDE.md
wc -w <<< "${BUCKLE_UP_SECTION}"
```

### Autonomy Alignment

| autonomy | Expected Content |
|----------|------------------|
| 3 (high) | `<default_to_action>` or "implement rather than suggest" |
| 2 (balanced) | `<balanced_action>` or "proceed for straightforward" |
| 1 (low) | `<confirm_before_action>` or "wait for approval" |

```bash
# Search CLAUDE.md for autonomy markers
grep -q "default_to_action\|implement rather than" CLAUDE.md
```

### Methodology References

All methodologies in `state.methodologyRefs` should appear in CLAUDE.md:

```bash
for ref in "${METHODOLOGY_REFS[@]}"; do
  grep -qi "$ref" CLAUDE.md || echo "Missing methodology: $ref"
done
```

---

## Severity Levels

| Level | Action |
|-------|--------|
| **Error** | Must fix before proceeding (invalid JSON, missing required config) |
| **Warning** | Should fix but can continue (missing env var, word count exceeded) |
| **Info** | Informational only (extra tools installed, methodology not referenced) |

---

## Output Template

```markdown
## Verification Report

### Operational [✓/⚠/✗]
- [x] {count} MCPs configured in ~/.claude.json
- [x] {count} plugins installation commands provided
- [ ] Missing env var: BRAVE_API_KEY

### Coherent [✓/⚠/✗]
- [x] No duplicate MCP entries
- [x] No hook conflicts detected
- [x] All CLAUDE.md references valid

### Well-Defined [✓/⚠/✗]
- [x] All JSON configs valid
- [x] Hook syntax valid
- [x] State file complete

### Matches Spec [✓/⚠/✗]
- [x] {installed}/{approved} tools configured
- [x] Word count: {count} (target: <{target})
- [x] Autonomy setting applied

### Summary
- Errors: {n}
- Warnings: {n}
- Status: [PASS/WARN/FAIL]

### Actions Required
1. {action if any}

[Fix issues] | [Continue anyway] | [Rollback]
```
