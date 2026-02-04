# buckle-up

> Strap in — we're configuring this project properly.

**buckle-up** is a Claude Code plugin that uses your research catalogue to configure the optimal toolset for any project.

## The Problem

You've researched 30+ AI coding tools. Now you're starting a new project and need to pick the right combination. Do you:

A) Spend an hour re-reading all your notes
B) Install everything and mass-produce ~/.claude.json backups
C) Run `/buckle-up` and let it figure it out

## How It Works

```mermaid
flowchart TD
    A["/buckle-up"] --> B{Path provided?}
    B -->|yes| C{Index stale?}
    B -->|no| B1{Choose catalogue}
    B1 -->|"Use existing"| B2[Enter path]
    B1 -->|"Clone readymade"| B3["git clone razpetel/research-catalogue"]
    B2 --> C
    B3 --> C
    C -->|"hash changed"| D["Rebuild index<br/>(shows progress)"]
    C -->|"hash matches"| E{Previous run?}
    D --> E
    E -->|yes| F{Re-run mode?}
    E -->|no| G[Detect existing config]
    F -->|Resume| L1
    F -->|Upgrade| G
    F -->|Re-interview| G
    F -->|Reset| Z[Remove config]
    G --> H["Interview<br/>(5-10 questions)"]
    H --> I[Score all tools]
    I --> J["Top 10 candidates<br/>(category coverage)"]
    J --> K["Present plan<br/>[Apply|Edit|Explain]"]
    K -->|approve| R["🔍 research-agent<br/>(fetch latest details)"]
    R --> L1["Apply MCPs + Plugins"]
    L1 --> L2["📝 config-writer-agent<br/>(generate CLAUDE.md + hooks)"]
    L2 --> V["✓ verification-agent<br/>(validate config)"]
    V -->|pass| M[Done]
    V -->|issues| FIX[Fix issues]
    FIX --> V
    Z --> M
```

**The key steps:**

1. **Index** — Reads your research catalogue, extracts structured data (cached)
2. **Interview** — Asks 5-10 smart questions about your project
3. **Score** — Ranks every tool against your specific needs
4. **Research** — Agent fetches latest details for approved tools
5. **Configure** — Agent generates CLAUDE.md + hooks using best practices
6. **Verify** — Agent validates everything works before declaring done

## Prerequisites

A research catalogue with:
- `catalogue.md` — Index of researched tools
- `catalogue/*.md` — Individual research reports

Don't have one? Two options:
- **Quick start:** Clone the [readymade catalogue](https://github.com/razpetel/research-catalogue) (buckle-up offers this automatically)
- **Build your own:** Install [fomo-researcher](https://github.com/razpetel/fomo-researcher) and run `/research` on tools you care about

## Insights Integration

Buckle-up automatically gathers usage patterns from `/insights` to personalize interview questions. If no recent insights exist, it offers to generate them.

## Installation

```bash
/plugin marketplace add razpetel/buckle-up
/plugin install buckle-up@razpetel
```

Restart Claude Code. (Yes, really.)

## Usage

```bash
# Choose catalogue interactively (use existing or clone readymade)
/buckle-up

# Explicit catalogue path
/buckle-up /path/to/catalogue.md
```

## What Gets Configured

| Component | How |
|-----------|-----|
| **MCPs** | Added to `~/.claude.json` |
| **Plugins** | Installation commands provided |
| **CLAUDE.md** | Methodology references added |
| **Hooks** | Test gates, TDD reminders |

## Re-runs

Changed your mind? Discovered a shiny new tool? Run `/buckle-up` again to:

- **Resume** — Finish interrupted setup
- **Upgrade** — Check for new tools in catalogue
- **Re-interview** — Start fresh with different needs
- **Reset** — Remove all buckle-up configuration

## State

- Configuration saved to `.claude/buckle-up-state.json`
- Backups at `.claude/buckle-up-backup/`
- Index cached at `{catalogue-dir}/.toolshed-index.json`

## How Scoring Works

Each tool is scored across 5 dimensions:

| Dimension | What It Measures |
|-----------|------------------|
| Team fit | Solo vs team, matches your situation |
| Maturity | Production-ready vs beta |
| Complexity | Minimal vs feature-rich, matches your preference |
| Token efficiency | Context usage |
| Autonomy | Human-in-loop vs overnight autonomous |

Weights adjust based on your answers. Bonuses for complementary tools, penalties for conflicts.

## Agents

Buckle-up delegates specialized tasks to agents:

| Agent | When | What It Does |
|-------|------|--------------|
| **research-agent** | After you approve | Fetches latest versions, install commands, breaking changes |
| **config-writer-agent** | During apply | Generates CLAUDE.md and hooks using best practices |
| **verification-agent** | After config | Validates everything works before declaring done |

The agents respect your preferences:
- Token-conscious? Minimal CLAUDE.md (<500 words)
- High autonomy? Proactive hooks, less confirmation
- Production project? Test gates and quality checks

## License

MIT

---

*Built because manually configuring Claude Code for every project is not a personality trait.*
