# Tool Categories

## Category Definitions

### Orchestration
**Purpose:** Coordinate AI agent workflows, parallel execution, task management

**Tools:**
- superpowers (obra/superpowers)
- oh-my-claudecode
- ralph
- multiclaude
- Auto-Claude
- cc10x
- Get Shit Done (GSD)
- CodeMachine-CLI

**Relevance:** Always relevant

---

### Memory
**Purpose:** Persist context across sessions, learn from interactions

**Tools:**
- Mem0
- OrchestKit (memory layer component)

**Relevance:** If interview.memory = "yes" or "maybe"

---

### Methodology
**Purpose:** Development practices, prompting techniques, workflows

**Tools:**
- Cole Medin's PIV Loop
- Context Engineering
- HDD (Human-Driven Development)
- Claude 4 Best Practices
- Claude That Learns

**Relevance:** Always relevant (added to CLAUDE.md as references, not installed)

---

### Browser
**Purpose:** Browser automation, web scraping, testing

**Tools:**
- agent-browser

**Relevance:** If interview.browser = "yes" or "maybe"

---

### Debugging/Observability
**Purpose:** Understand what Claude is doing, debug issues

**Tools:**
- claude-trace

**Relevance:** If interview.maturity = "production" OR interview.autonomy >= 2

---

### Infrastructure
**Purpose:** Deployment, hosting, data sync

**Tools:**
- Railway
- SourceSync.ai

**Relevance:** If interview.projectType in ["web-app", "API service"]

---

### Reference
**Purpose:** Comparison guides, educational resources

**Tools:**
- Vector DB Comparison
- Vibe Code Camp Summarizer
- AGENTS.md vs Skills evaluation

**Relevance:** Added to CLAUDE.md as references if topically relevant

---

## Selection Rules

### Top 10 Selection

1. Score all tools using scoring matrix
2. For each RELEVANT category:
   - Take top 2 tools by score
   - If category only has 1 tool, take it
3. Fill remaining slots (up to 10 total) with highest-scoring tools regardless of category
4. Never exceed 10 candidates

### Overlap Handling (in LLM Reasoning Phase)

When two tools in same category both make top 10:
- LLM selects ONE based on better fit to specific user needs
- Document why the other was excluded

### Methodology Special Case

Methodology tools are NEVER installed — they're added to CLAUDE.md as reference links. They don't count toward the "install" limit but do count toward top 10 candidates.
