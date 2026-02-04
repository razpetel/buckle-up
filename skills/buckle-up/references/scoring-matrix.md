# Scoring Matrix

## Dimensions

| Dimension | 0 | 1 | 2 | 3 |
|-----------|---|---|---|---|
| **Team fit** | Wrong size entirely | Usable but not ideal | Good fit | Explicitly built for this |
| **Maturity** | Beta/warnings | Mixed sentiment | Positive, stable | Very Positive, production-proven |
| **Complexity match** | Way over/under | Slight mismatch | Good match | Perfect match |
| **Token efficiency** | Token-heavy | Average | Efficient | 90%+ reduction claims |
| **Autonomy match** | Wrong model entirely | Partial fit | Good fit | Exactly what they want |

## Weight Multipliers

Derived from interview answers:

| Interview Signal | Weight |
|------------------|--------|
| Autonomy score 3 OR "overnight runs" mentioned | Autonomy × 2 |
| Token-conscious score 3 | Token efficiency × 2 |
| Maturity = "production" | Maturity × 1.5 |
| Complexity preference = "minimal" | Complexity × 1.5 (inverted) |

Default weight: 1.0

## Bonuses

| Condition | Bonus |
|-----------|-------|
| Tool supports "maybe" feature user mentioned | +1 |
| Tool complements tool user wants to keep | +1 |
| Tool explicitly recommended for user's project type in report | +1 |

## Penalties

| Condition | Penalty |
|-----------|---------|
| Warning in report (security, stability, etc.) | -1 per warning (max -3) |
| Tool conflicts with tool user wants to keep | -2 |

## Formula

```
base_score = Σ(dimension_score × weight_multiplier)
final_score = base_score + bonuses - penalties
```

## Tiebreaker

1. Sentiment: Very Positive (4) > Positive (3) > Mixed (2) > Concerned (1)
2. Stars (higher wins)

## Index Schema

When indexing a tool, extract:

```json
{
  "slug": "tool-slug",
  "name": "Full Tool Name",
  "category": "orchestration|memory|methodology|browser|debugging|infrastructure|reference",
  "teamFit": ["solo", "small-team", "large-team"],
  "maturity": "very-positive|positive|mixed|concerned",
  "complexity": "minimal|moderate|feature-rich",
  "tokenEfficiency": "efficient|neutral|heavy",
  "autonomy": "autonomous|human-in-loop|manual",
  "keywords": ["keyword1", "keyword2"],
  "bestFor": "one-line description of ideal use case",
  "warnings": ["warning1", "warning2"],
  "stars": 12345,
  "requiresMcp": ["mcp-name"],
  "complementsTools": ["tool-a", "tool-b"],
  "overlapsTools": ["tool-c", "tool-d"]
}
```

**Category assignment:** Assign PRIMARY category only. For hybrid tools, choose category matching primary use case.
```
