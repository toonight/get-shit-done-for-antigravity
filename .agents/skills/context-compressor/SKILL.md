---
name: Context Compressor
description: Strategies for compressing context to maximize token efficiency
---

# Context Compressor Skill

<role>
You are a context compression specialist. Your job is to maintain rich understanding while using minimal tokens.

**Core principle:** Compress aggressively, decompress only when needed.
</role>

---

## Compression Strategies

### Strategy 1: Summary Mode

**When:** You've fully understood a file and may need to reference it later.

**How:**
```markdown
## File Summary: src/auth/login.ts

**Purpose:** Handles user login via email/password
**Key functions:**
- handleLogin(req, res) → Validates credentials, returns JWT
- validateCredentials(email, password) → Checks against DB
**Dependencies:** bcrypt, jose, database
**Tokens saved:** ~400 (95 lines not reloaded)
```

**Use instead of:** Re-reading the full file

---

### Strategy 2: Outline Mode

**When:** You need to understand a file's structure but not implementation details.

**How:**
```markdown
## Outline: src/services/payment.ts (127 lines)

- L1-15: Imports and types
- L17-35: PaymentService class
  - L20: constructor(config)
  - L25: processPayment(amount, method)
  - L45: refund(transactionId)
  - L67: getHistory(userId)
- L90-127: Helper functions
```

**Tokens:** ~50 vs ~500 for full file

---

### Strategy 3: Diff-Only Mode

**When:** You've already seen a file and need to understand changes.

**How:**
```markdown
## Changes to: src/config.ts

Added:
- L45: TOKEN_BUDGET_THRESHOLD = 0.5
- L46: COMPRESSION_ENABLED = true

Modified:
- L12: MAX_CONTEXT → increased from 100000 to 150000
```

**Use for:** Reviewing modifications, understanding updates

---

### Strategy 4: Reference Mode

**When:** You need to track a file without loading it.

**How:**
```markdown
## References

| File | Last Seen | Summary | Load If |
|------|-----------|---------|---------|
| auth.ts | Task 2 | Login handling | Auth bugs |
| db.ts | Task 1 | Postgres client | DB errors |
| utils.ts | Never | Utility funcs | Helper needed |
```

**Cost:** ~10 tokens vs ~200+ per file

---

### Strategy 5: Progressive Disclosure

**When:** Unsure how much detail is needed.

**Process:**
1. Start with outline (Level 1)
2. If insufficient, load key functions (Level 2)
3. If still stuck, load related code (Level 3)
4. Full file only as last resort (Level 4)

```
L1: Outline → "I see handleLogin at L25"
L2: Function → "handleLogin validates then calls createToken"
L3: Related → "createToken uses jose.sign with HS256"
L4: Full → Only for complex debugging
```

---

## Compression Triggers

### Automatic Compression Points

| Trigger | Action |
|---------|--------|
| After understanding a file | Create summary |
| Switching tasks | Compress previous context |
| Budget at 50% | Aggressive outline mode |
| Budget at 70% | Summary-only mode |
| End of wave | Full compression pass |

---

## Decompression Protocol

When you need details from compressed context:

1. **Check summary first** — Often sufficient
2. **Load specific section** — If summary incomplete
3. **Full load as last resort** — And re-compress after

```markdown
## Decompression Log

| File | Reason | Level | Tokens |
|------|--------|-------|--------|
| auth.ts | Debug login | L2 (func) | +150 |
| db.ts | Check query | L3 (snippet) | +50 |
```

---

## Compression Format Templates

### Summary Template

```markdown
## 📦 [filename]
**Purpose:** [one line]
**Key exports:** [list]
**Dependencies:** [list]
**Patterns:** [notable patterns used]
**Watch for:** [gotchas or edge cases]
```

### Outline Template

```markdown
## 📋 [filename] (N lines)
- L[start]-[end]: [section name]
  - L[n]: [key item]
  - L[n]: [key item]
```

### Diff Template

```markdown
## Δ [filename]
**+** [additions]
**-** [removals]
**~** [modifications]
```

---

## Integration

Works with:
- `token-budget` — Triggers compression at thresholds
- `context-fetch` — Provides input for compression
- `context-health-monitor` — Monitors compression effectiveness

---

## Anti-Patterns

❌ **Keeping full files in mental context** — Compress after understanding
❌ **Re-reading instead of referencing** — Use summaries
❌ **Loading full file for one function** — Use outline + target
❌ **Skipping compression "to save time"** — Costs more later

---

*Part of GSD v1.6 Token Optimization. See docs/token-optimization-guide.md for examples.*
