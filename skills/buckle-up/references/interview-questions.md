# Interview Questions

## Core Questions (Always Ask)

### Q1: Project Type
**Ask:** "What are you building?"

**Options:**
- CLI tool
- Web app
- API service
- Library/package
- Monorepo
- Other: [free text]

**Maps to:** Project type for "bestFor" matching

**Personalized (high confidence):**
> Your usage shows [dominantLanguage] ([percentage]%) across [topProjectArea] work.
> I'd infer: [inferredType]. Confirm?
> [CLI tool] [Web app] [API] [Library] [Monorepo ✓] [Other]

**Personalized (medium confidence):**
> Your projects lean toward [dominantLanguage]. What are you building?
> [options]

---

### Q2: Team Size
**Ask:** "Are you working solo or with a team?"

**Options:**
- Solo developer
- Small team (2-5 people)
- Larger team (6+)

**Maps to:** teamFit dimension

**Personalized (high confidence):**
> Your patterns suggest solo development ([sessionCount] sessions, power-user signals).
> Confirm: Solo?
> [Solo ✓] [Small team] [Larger team]

**Personalized (medium confidence):**
> Usage patterns lean toward individual work. Working solo or with a team?
> [Solo] [Small team] [Larger team]

---

### Q3: Maturity
**Ask:** "Is this a hobby/learning project or production/professional?"

**Options:**
- Hobby/learning
- Production/professional

**Maps to:** Maturity weight multiplier (production = 1.5x)

**Personalized (high confidence):**
> Your outcomes show [achievedPercentage]% fully achieved — production quality patterns.
> Confirm: Production/professional?
> [Hobby/learning] [Production ✓]

**Personalized (medium confidence):**
> Session patterns suggest [inferredMaturity] work. Hobby or production?
> [Hobby/learning] [Production/professional]

---

### Q4: Token Consciousness
**Ask:** "How token-conscious are you? (1 = don't care, 2 = somewhat, 3 = very)"

**Options:** 1, 2, 3

**Maps to:** Token efficiency weight (3 = 2x)

**Personalized (high confidence):**
> Token concerns rarely appear in your friction points — seems low priority.
> I'd infer level 1. Confirm?
> [1 ✓] [2] [3]

**Personalized (medium confidence):**
> How token-conscious are you?
> [1 = don't care] [2 = somewhat] [3 = very]

---

### Q5: Autonomy
**Ask:** "How much do you want to stay in the loop? (1 = supervise everything, 2 = check in periodically, 3 = let it run overnight)"

**Options:** 1, 2, 3

**Maps to:** Autonomy dimension and weight (3 = 2x)

**Personalized (high confidence):**
> Your key pattern: "[keyInsight]"
> Median response time: [medianResponseTime]s (you let Claude run).
>
> I'd infer autonomy level 3 (let it run overnight).
> [1] Supervise everything  [2] Check in  [3] Let it run ✓

**Personalized (medium confidence):**
> Your usage suggests [autonomyHint]. How autonomous do you want Claude?
> [1 = supervise] [2 = check in] [3 = let it run]

---

## Feature Questions (Contextual)

### Q6: Memory
**Ask:** "Do you need memory that persists across sessions?"

**Options:** Yes / No / Maybe

**Skip if:** Project type is "CLI tool" (typically stateless)

**Maps to:** Memory category relevance, "maybe" bonus

**Personalized (high confidence):**
> Your sessions show cross-session context patterns. Memory needed?
> [Yes ✓] [No] [Maybe]

**Personalized (medium confidence):**
> Do you need memory that persists across sessions?
> [Yes] [No] [Maybe]

---

### Q7: Browser Automation
**Ask:** "Will you need browser automation for testing or scraping?"

**Options:** Yes / No / Maybe

**Skip if:** Project type is "Library/package"

**Maps to:** Browser category relevance, "maybe" bonus

**Personalized (high confidence):**
> You've used browser tools ([browserToolUsage] sessions). Browser automation needed?
> [Yes ✓] [No] [Maybe]

**Personalized (medium confidence):**
> Will you need browser automation for testing or scraping?
> [Yes] [No] [Maybe]

---

### Q8: Complexity Preference
**Ask:** "Do you prefer minimal setup or feature-rich tooling?"

**Options:**
- Minimal (fewer tools, simpler config)
- Balanced
- Feature-rich (more capabilities, more complexity)

**Maps to:** Complexity weight multiplier (minimal = 1.5x inverted)

**Personalized (high confidence):**
> You actively use [toolCount]+ tools. Feature-rich preference?
> [Minimal] [Balanced] [Feature-rich ✓]

**Personalized (medium confidence):**
> Do you prefer minimal setup or feature-rich tooling?
> [Minimal] [Balanced] [Feature-rich]

---

## Open Questions (Optional)

### Q9: Existing Tools
**Ask:** "Any existing tools or MCPs you want to keep?"

**Type:** Free text

**Skip if:** No `.claude/` directory exists (new project)

**Maps to:** Complement bonuses, conflict penalties

**Personalized (high confidence):**
> Your top tools: [existingTools] (used [totalUses]+ times).
> Keep these? Add any others?
> [Keep all] [Keep some: ___] [Start fresh]

**Personalized (medium confidence):**
> I see you've used [toolList]. Any tools or MCPs you want to keep?
> [free text]

---

### Q10: Notes
**Ask:** "Anything else I should know about your project?"

**Type:** Free text

**Always last, always optional**

**Maps to:** Context for LLM reasoning

**Personalized (when friction data exists):**
> Your friction points: [frictionSummary]
> Want me to prioritize solving any of these? Anything else to note?
> [free text]

**Personalized (no friction data):**
> Anything else I should know about your project?
> [free text]

---

## Depth Questions (If Ambiguous)

Trigger when answers conflict or are unclear:

### Memory Clarification
**Trigger:** Q6 = "Maybe"
**Ask:** "What kind of memory would you use? (e.g., remembering user preferences, cross-session context, learning from past interactions)"

### Autonomy vs Tokens Conflict
**Trigger:** Q5 = 3 AND Q4 = 3
**Ask:** "You want autonomous overnight runs but also care about tokens. Which matters more if you had to choose?"

### Existing Tools Clarification
**Trigger:** Q9 mentions tool that could conflict
**Ask:** "You mentioned [tool]. What do you use it for? (helps me avoid recommending overlapping tools)"

---

## Interview State Schema

Save after each answer to `.claude/buckle-up-state.json`:

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
    "projectType": "web-app",
    "teamSize": "solo",
    "maturity": "production",
    "tokenConscious": 2,
    "autonomy": 3,
    "memory": "yes",
    "browser": "maybe",
    "complexity": "moderate",
    "keepTools": ["brave-search"],
    "notes": "Building a SaaS dashboard",

    "overrides": {
      "autonomy": { "inferred": 3, "userChoice": 3, "overridden": false },
      "teamSize": { "inferred": "solo", "userChoice": "solo", "overridden": false }
    }
  }
}
```

See: `references/insights-integration.md` for extraction schema and inference mapping.
