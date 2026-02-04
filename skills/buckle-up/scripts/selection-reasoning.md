# Selection Reasoning Prompt

Use this prompt after scoring to select the minimal optimal toolset.

---

## Context

You are selecting the final toolset for a user's project.

### User Needs (from interview)

{interview_summary}

### Top 10 Candidates (by score)

{scored_tools_table}

### Existing Tools User Wants to Keep

{existing_tools}

---

## Task

Select the **MINIMAL** set of tools that:

1. **Covers all stated needs** — Every user requirement maps to a selected tool
2. **No overlapping functionality** — If two tools do the same thing, pick ONE
3. **Respects complexity preference** — Don't recommend 10 tools to someone who wants minimal setup
4. **Works with existing tools** — No conflicts with what they're keeping

---

## Decision Process

For each tool in top 10, ask:

1. Does this cover a user need that nothing else covers better?
2. Does this overlap with a higher-scoring tool I already selected?
3. Does this conflict with tools the user wants to keep?
4. Is this overkill for their complexity preference?

---

## Output Format

### Selected Tools

For each selected tool:

**[Tool Name]** — [Category]
- **Why selected:** [Cite specific user need this addresses]
- **Unique value:** [What this provides that alternatives don't]

### Methodology References

List methodology reports to add to CLAUDE.md (not installed, just linked):

- **[Report Name]** — [One sentence on why it's relevant]

### Excluded Tools

For each tool from top 10 that was NOT selected:

**[Tool Name]**
- **Why excluded:** [Overlap with X / User said Y / Warning about Z]

### Configuration Summary

```
MCPs to install: [list]
Plugins to install: [list]
Hooks to configure: [list]
CLAUDE.md references: [list]
```

---

## Example Output

### Selected Tools

**superpowers** — Orchestration
- **Why selected:** User wants structured workflows; matches "production" maturity need
- **Unique value:** TDD + brainstorm skills; highest-rated orchestration tool

**Mem0** — Memory
- **Why selected:** User answered "yes" to memory; production-ready
- **Unique value:** Only enterprise-grade memory solution in catalogue

### Methodology References

- **Context Engineering** — User is token-conscious (score 2); provides reduction strategies
- **PIV Loop** — Complements superpowers workflow

### Excluded Tools

**oh-my-claudecode**
- **Why excluded:** Overlaps with superpowers; superpowers scored higher and better fits "human-in-loop" preference

**ralph**
- **Why excluded:** User wants to "stay in the loop" (autonomy=1); ralph is for overnight autonomous runs

### Configuration Summary

```
MCPs to install: brave-search, mem0
Plugins to install: superpowers@obra
Hooks to configure: pre-commit-test-gate
CLAUDE.md references: Context Engineering, PIV Loop, Claude 4 Best Practices
```
