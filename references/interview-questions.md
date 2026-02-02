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

---

### Q2: Team Size
**Ask:** "Are you working solo or with a team?"

**Options:**
- Solo developer
- Small team (2-5 people)
- Larger team (6+)

**Maps to:** teamFit dimension

---

### Q3: Maturity
**Ask:** "Is this a hobby/learning project or production/professional?"

**Options:**
- Hobby/learning
- Production/professional

**Maps to:** Maturity weight multiplier (production = 1.5x)

---

### Q4: Token Consciousness
**Ask:** "How token-conscious are you? (1 = don't care, 2 = somewhat, 3 = very)"

**Options:** 1, 2, 3

**Maps to:** Token efficiency weight (3 = 2x)

---

### Q5: Autonomy
**Ask:** "How much do you want to stay in the loop? (1 = supervise everything, 2 = check in periodically, 3 = let it run overnight)"

**Options:** 1, 2, 3

**Maps to:** Autonomy dimension and weight (3 = 2x)

---

## Feature Questions (Contextual)

### Q6: Memory
**Ask:** "Do you need memory that persists across sessions?"

**Options:** Yes / No / Maybe

**Skip if:** Project type is "CLI tool" (typically stateless)

**Maps to:** Memory category relevance, "maybe" bonus

---

### Q7: Browser Automation
**Ask:** "Will you need browser automation for testing or scraping?"

**Options:** Yes / No / Maybe

**Skip if:** Project type is "Library/package"

**Maps to:** Browser category relevance, "maybe" bonus

---

### Q8: Complexity Preference
**Ask:** "Do you prefer minimal setup or feature-rich tooling?"

**Options:**
- Minimal (fewer tools, simpler config)
- Balanced
- Feature-rich (more capabilities, more complexity)

**Maps to:** Complexity weight multiplier (minimal = 1.5x inverted)

---

## Open Questions (Optional)

### Q9: Existing Tools
**Ask:** "Any existing tools or MCPs you want to keep?"

**Type:** Free text

**Skip if:** No `.claude/` directory exists (new project)

**Maps to:** Complement bonuses, conflict penalties

---

### Q10: Notes
**Ask:** "Anything else I should know about your project?"

**Type:** Free text

**Always last, always optional**

**Maps to:** Context for LLM reasoning

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
  }
}
```
