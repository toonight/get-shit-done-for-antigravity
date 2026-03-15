# Token Optimization Guide

> Practical strategies for reducing token consumption while maintaining quality.

---

## Why Token Optimization Matters

| Issue | Impact |
|-------|--------|
| Excessive file loading | Higher costs, slower responses |
| Context accumulation | Quality degradation after 50% |
| Re-reading files | Wasted tokens on understood content |
| Full files when snippets suffice | 10x token usage |

**Goal:** Maximize output quality per token spent.

---

## The Token Efficiency Stack

```
┌─────────────────────────────────────┐
│ 1. Search-First (context-fetch)    │ ← Find before loading
├─────────────────────────────────────┤
│ 2. Budget Tracking (token-budget)  │ ← Know your limits
├─────────────────────────────────────┤
│ 3. Compression (context-compressor)│ ← Minimize footprint
├─────────────────────────────────────┤
│ 4. Health Monitoring               │ ← Prevent degradation
└─────────────────────────────────────┘
```

---

## Quick Reference: Token Costs

### By Content Type

| Type | Tokens/Line | 100 Lines = |
|------|-------------|-------------|
| Dense code | 6 | ~600 tokens |
| Standard code | 4 | ~400 tokens |
| Markdown | 3 | ~300 tokens |
| Sparse YAML | 2 | ~200 tokens |

### By File Size

| File Lines | Strategy |
|------------|----------|
| <50 | Load freely |
| 50-200 | Outline first |
| 200-500 | Search + snippets |
| 500+ | Never load fully |

---

## Optimization Patterns

### Pattern 1: Search → Outline → Target

```
Step 1: Search for "handlePayment"
  → Found in: payment.ts:45, checkout.ts:120

Step 2: Get outline of payment.ts
  → L45-80: handlePayment function

Step 3: Load only L45-80
  → 35 lines (~140 tokens) vs 400 lines (~1600 tokens)
  → Saved: ~90%
```

### Pattern 2: Summarize After Understanding

```
After reading auth.ts:

## Summary: auth.ts
- Exports: login, logout, validateToken
- Pattern: Express middleware
- DB: queries users table
- JWT: uses jose library

Next time: Reference summary, don't reload
```

### Pattern 3: Progressive Disclosure

```
Need: Understand login flow

Level 1: Outline
  → "login at L45, uses validateCredentials at L67"
  → Often sufficient

Level 2: Key function
  → Load L45-65 only
  → Understand core logic

Level 3: Dependencies
  → Load validateCredentials (L67-85)
  → Only if L2 insufficient

Level 4: Full file
  → Last resort, re-compress after
```

---

## Anti-Patterns to Avoid

### ❌ The "Context Dump"

```
BAD:
"Let me read all the files in src/ to understand the project"
→ 50 files × 200 lines × 4 tokens = 40,000 tokens

GOOD:
"Let me search for 'main entry' and 'router'"
→ 2 targeted searches, ~500 tokens
```

### ❌ The "Just In Case" Load

```
BAD:
"Loading utils.ts in case I need it later"
→ Probably won't need it, wasted tokens

GOOD:
"Noting utils.ts exists, will load if needed"
→ Zero tokens until actually needed
```

### ❌ The Re-Read

```
BAD:
"Reading config.ts again to check the port"
→ Already read it twice = 1200 tokens

GOOD:
"From my earlier analysis, port is on L15"
→ Zero additional tokens
```

---

## Budget Checkpoints

### Before Starting Work

```markdown
□ Do I know my current budget usage?
□ Have I tried searching before loading?
□ Am I loading files I've already understood?
```

### During Execution

```markdown
□ Am I at >50%? Time to compress.
□ Am I re-reading files? Use summaries.
□ Can I use outline instead of full file?
```

### After Each Wave

```markdown
□ Have I compressed context for next wave?
□ Are summaries documented in STATE.md?
□ Would a fresh session be more efficient?
```

---

## Integration with GSD

| GSD Workflow | Token Optimization |
|--------------|-------------------|
| `/map` | Generate outline, not full read |
| `/plan` | Budget estimate per task |
| `/execute` | Load minimal per task |
| `/verify` | Targeted evidence only |
| `/pause` | Compress and dump state |

---

## Metrics

Track these for improvement:

| Metric | Good | Poor |
|--------|------|------|
| Files fully loaded | <3 per wave | 10+ |
| Search:Load ratio | 3:1 | 1:3 |
| Re-reads | 0 | 3+ |
| Budget at wave end | <50% | >70% |

---

*See also:*
- *[.agents/skills/token-budget/SKILL.md](.agents/skills/token-budget/SKILL.md)*
- *[.agents/skills/context-compressor/SKILL.md](.agents/skills/context-compressor/SKILL.md)*
- *[PROJECT_RULES.md](PROJECT_RULES.md) — Token Efficiency Rules*
