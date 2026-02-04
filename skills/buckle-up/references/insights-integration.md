# Insights Integration

Buckle-up uses Claude Code's `/insights` command to personalize interview questions. This document defines the extraction schema, inference mapping, and question patterns.

## Extraction Schema

Parse `~/.claude/usage-data/report.html` for:

| Data | HTML Selector | Maps To |
|------|--------------|---------|
| Project areas | `.project-area .area-name` | Q1: Project Type |
| Session counts | `.project-area .area-count` | Confidence weighting |
| Key insight | `.key-insight` | Q5: Autonomy |
| Response time | Chart data (median) | Q5: Autonomy |
| Tool usage | `.bar-row .bar-label`, `.bar-row .bar-value` | Q9: Existing Tools |
| Languages | Language chart section | Q1: Project Type |
| Friction | `.friction-category` | Q10: Notes context |
| At-a-glance | `.glance-section` | Quick wins, blockers |
| Report date | `<meta name="generated">` or header | Staleness check |
| Session count | Summary header | Confidence baseline |

## Inference Mapping

| Question | Insight Signal | Inference Logic |
|----------|---------------|-----------------|
| Q1: Project Type | languages, projectAreas | Markdown 93% + "Documentation" area = docs project |
| Q2: Team Size | multi-clauding patterns, parallel sessions | Power-user pattern + solo indicators = solo dev |
| Q3: Maturity | outcomes, friction types | 72%+ fully achieved = production quality |
| Q4: Token Conscious | glance sections, friction mentions | Rarely mentioned token concerns = low priority |
| Q5: Autonomy | keyInsight, response time | "autonomous orchestration" + 60s+ median = level 3 |
| Q6: Memory | session persistence, cross-session refs | Long sessions + context references = likely yes |
| Q7: Browser | tool usage, project areas | Browser tools + web dev area = likely yes |
| Q8: Complexity | tool count, session patterns | Many tools active = feature-rich preference |
| Q9: Existing Tools | tool usage counts | Top tools with >100 uses |
| Q10: Notes | frictionSummary | Surface known pain points |

## Confidence Levels

| Level | Criteria | Behavior |
|-------|----------|----------|
| **High** | Clear signal + >500 sessions | Show inference prominently, user confirms |
| **Medium** | Reasonable signal, 100-500 sessions | Show inference as suggestion |
| **Low** | Weak/ambiguous signal or <100 sessions | Standard question, no inference shown |

## Personalized Question Patterns

### High Confidence (show inference, confirm)

```
Your insights show [observation].
I'd infer [answer]. Confirm: [options with inferred marked ✓]
```

Example:
```
Your key pattern: "autonomous research orchestration system"
Median response time: 61.6 seconds (you let Claude run).

I'd infer autonomy level 3 (let it run overnight).

[1] Supervise everything  [2] Check in  [3] Let it run ✓
```

### Medium Confidence (suggest, don't assume)

```
Patterns suggest [observation]. Is that accurate?
[options]
```

Example:
```
Your usage patterns suggest solo development (1307 sessions, power-user signals).
Working solo or with a team?

[Solo ✓]  [Small team]  [Larger team]
```

### Low Confidence / Missing

Use standard question from interview-questions.md without inference.

## Fallback Behavior

### No Report

1. Detect missing `~/.claude/usage-data/report.html`
2. Announce: "No usage insights found. Generating fresh report..."
3. Run `/insights` via Bash:
   ```bash
   echo "/insights" | claude -p 2>/dev/null
   ```
4. Wait for completion (check for report.html)
5. Parse fresh report, continue interview

### Stale Report (>14 days)

1. Check report generation date
2. Announce: "Your insights are [N] days old. Refreshing..."
3. Run `/insights` to regenerate
4. Parse fresh report, continue interview

### Partial Data

- If specific sections are missing, use standard questions for those
- Track which inferences were possible vs standard

### /insights Failure

1. If command fails or times out after 60s
2. Log warning to state: `insights.error = "generation failed"`
3. Continue with standard questions
4. No blocking behavior

## State Schema Extension

Add to `.claude/buckle-up-state.json`:

```json
{
  "insights": {
    "available": true,
    "reportPath": "~/.claude/usage-data/report.html",
    "gatheredAt": "2026-02-04T20:25:00Z",
    "stale": false,
    "sessionCount": 1307,
    "reportAgeDays": 3,

    "extracted": {
      "topProjectArea": "Decision Validation",
      "topProjectAreaCount": 550,
      "dominantLanguage": "Markdown",
      "autonomySignal": "autonomous",
      "autonomyEvidence": "autonomous research orchestration",
      "medianResponseTime": 61.6,
      "existingTools": ["brave-search", "context7"],
      "frictionSummary": "incomplete sessions, web fetch failures"
    },

    "inferences": {
      "projectType": { "guess": null, "confidence": "low" },
      "teamSize": { "guess": "solo", "confidence": "medium" },
      "maturity": { "guess": "production", "confidence": "medium" },
      "tokenConscious": { "guess": 1, "confidence": "low" },
      "autonomy": { "guess": 3, "confidence": "high" }
    }
  },

  "interview": {
    "overrides": {
      "autonomy": { "inferred": 3, "userChoice": 3, "overridden": false },
      "teamSize": { "inferred": "solo", "userChoice": "solo", "overridden": false }
    }
  }
}
```

## Implementation Notes

### Parsing Strategy

1. Use simple regex or DOM-like parsing of report.html
2. Extract text content, not HTML structure (more robust)
3. Handle missing sections gracefully
4. Cache extracted data in state to avoid re-parsing

### Pre-fill vs Skip

Never skip questions entirely. Always ask, but contextualize:
- Pre-fill with inference (user can override)
- "Grain of salt" — insights inform but don't decide
- Track overrides to improve future recommendations
