---
name: Token Budget
description: Manages token budget estimation and tracking to prevent context overflow
---

# Token Budget Skill

<role>
You are a token-efficient agent. Your job is to maximize output quality while minimizing token consumption.

**Core principle:** Every token counts. Load only what you need, when you need it.
</role>

---

## Token Estimation

### Quick Estimates

| Content Type | Tokens/Line | Notes |
|--------------|-------------|-------|
| Code | ~4-6 | Depends on verbosity |
| Markdown | ~3-4 | Less dense than code |
| JSON/YAML | ~5-7 | Structured, repetitive |
| Comments | ~3-4 | Natural language |

**Rule of thumb:** `tokens ≈ lines × 4`

### File Size Categories

| Category | Lines | Est. Tokens | Action |
|----------|-------|-------------|--------|
| Small | <50 | <200 | Load freely |
| Medium | 50-200 | 200-800 | Consider outline first |
| Large | 200-500 | 800-2000 | Use search + snippets |
| Huge | 500+ | 2000+ | Never load fully |

---

## Budget Thresholds

Based on PROJECT_RULES.md context quality thresholds:

| Usage | Quality | Budget Status |
|-------|---------|---------------|
| 0-30% | PEAK | ✅ Proceed freely |
| 30-50% | GOOD | ⚠️ Be selective |
| 50-70% | DEGRADING | 🔶 Compress & summarize |
| 70%+ | POOR | 🛑 State dump required |

---

## Budget Tracking Protocol

### Before Each Task

1. **Estimate current usage:**
   - Count files in context
   - Estimate tokens per file
   - Calculate approximate %

2. **Check budget status:**
   ```
   Current: ~X,000 tokens (~Y%)
   Budget: [PEAK|GOOD|DEGRADING|POOR]
   ```

3. **Adjust strategy:**
   - PEAK: Proceed normally
   - GOOD: Prefer search-first
   - DEGRADING: Use outlines only
   - POOR: Trigger state dump

### During Execution

Track cumulative context:

```markdown
## Token Tracker

| Phase | Files Loaded | Est. Tokens | Cumulative |
|-------|--------------|-------------|------------|
| Start | 0 | 0 | 0 |
| Task 1 | 2 | ~400 | ~400 |
| Task 2 | 3 | ~600 | ~1000 |
```

---

## Optimization Strategies

### 1. Progressive Loading

```
Level 1: Outline only (function signatures)
Level 2: + Key functions (based on task)
Level 3: + Related code (if needed)
Level 4: Full file (only if essential)
```

### 2. Just-In-Time Loading

- Load file only when task requires it
- Unload mentally after task complete
- Don't preload "just in case"

### 3. Search Before Load

Always use context-fetch skill first:
1. Search for relevant terms
2. Identify candidate files
3. Load only needed sections

### 4. Summarize & Compress

After understanding a file:
- Document key insights in STATE.md
- Reference summary instead of re-reading
- Use "I've analyzed X, it does Y" pattern

---

## Budget Alerts

### At 50% Budget

```
⚠️ TOKEN BUDGET: 50%
Switching to efficiency mode:
- Outlines only for new files
- Summarizing instead of loading
- Recommending compression
```

### At 70% Budget

```
🛑 TOKEN BUDGET: 70%
Quality degradation likely. Recommend:
1. Create state snapshot
2. Run /pause
3. Continue in fresh session
```

---

## Integration

This skill integrates with:
- `context-fetch` — Search before loading
- `context-health-monitor` — Quality tracking
- `context-compressor` — Compression strategies
- `/pause` and `/resume` — Session handoff

---

## Anti-Patterns

❌ **Loading files "for context"** — Search first
❌ **Re-reading same file** — Summarize once
❌ **Full file when snippet suffices** — Target load
❌ **Ignoring budget warnings** — Quality will degrade

---

*Part of GSD v1.6 Token Optimization. See PROJECT_RULES.md for efficiency rules.*
