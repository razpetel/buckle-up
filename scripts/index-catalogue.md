# Index Catalogue Prompt

Use this prompt to generate the toolshed index from research reports.

---

## Instructions

You are indexing a research catalogue for the buckle-up tool selection system.

For each tool report, extract structured data that enables scoring against user needs.

## Input

You will receive:
1. The catalogue.md index file (list of all tools with summaries)
2. Individual report files for each tool

## Output Format

Generate a JSON index with this structure:

```json
{
  "version": "1.0",
  "catalogueHash": "<SHA-256 of catalogue.md>",
  "generatedAt": "<ISO timestamp>",
  "tools": [
    {
      "slug": "<url-safe identifier>",
      "name": "<full tool name>",
      "category": "<one of: orchestration|memory|methodology|browser|debugging|infrastructure|reference>",
      "teamFit": ["<solo|small-team|large-team>"],
      "maturity": "<very-positive|positive|mixed|concerned>",
      "complexity": "<minimal|moderate|feature-rich>",
      "tokenEfficiency": "<efficient|neutral|heavy>",
      "autonomy": "<autonomous|human-in-loop|manual>",
      "keywords": ["<searchable terms>"],
      "bestFor": "<one sentence describing ideal use case>",
      "warnings": ["<any cautions from report>"],
      "stars": <github stars as integer>,
      "complementsTools": ["<tools that work well with this>"],
      "overlapsTools": ["<tools with similar functionality>"]
    }
  ]
}
```

## Field Extraction Rules

### slug
- Lowercase, hyphenated version of tool name
- Example: "obra/superpowers" → "superpowers"

### category
Map based on tool's primary function:
- Workflow/agent orchestration → "orchestration"
- Session persistence/memory → "memory"
- Development methodology/practices → "methodology"
- Browser automation → "browser"
- Debugging/logging/observability → "debugging"
- Deployment/hosting/data → "infrastructure"
- Guides/comparisons/educational → "reference"

### teamFit
Extract from report's "best for" or target audience:
- "solo developer" / "individual" → include "solo"
- "small team" / "2-5" / "startup" → include "small-team"
- "enterprise" / "10+" / "large team" → include "large-team"

### maturity
Map from report's sentiment field:
- "Very Positive" → "very-positive"
- "Positive" → "positive"
- "Mixed" → "mixed"
- "Concerned" or warnings about stability → "concerned"

### complexity
Infer from feature count and setup requirements:
- Few features, simple setup → "minimal"
- Moderate features, some config → "moderate"
- Many features, complex setup → "feature-rich"

### tokenEfficiency
Look for explicit mentions:
- "90% reduction" / "token efficient" → "efficient"
- "token heavy" / "context expensive" → "heavy"
- No mention → "neutral"

### autonomy
Based on workflow style:
- "overnight" / "autonomous" / "unattended" → "autonomous"
- "human in loop" / "approval" / "interactive" → "human-in-loop"
- Requires constant interaction → "manual"

### keywords
Extract:
- Technology names (TDD, React, Python)
- Concepts (workflow, memory, parallel)
- Problem domains (debugging, testing, deployment)

### bestFor
One sentence from report summary or recommendation.

### warnings
Any security issues, stability concerns, or "wait for" recommendations.

### stars
GitHub stars as integer. Use 0 if not applicable.

### complementsTools / overlapsTools
Extract from report if mentioned, or infer from category:
- Same category = likely overlaps
- Different category but mentioned together = complements

## Validation

After generating, verify:
- [ ] Every tool has all required fields
- [ ] Category is one of the allowed values
- [ ] Maturity matches sentiment from report
- [ ] No duplicate slugs
