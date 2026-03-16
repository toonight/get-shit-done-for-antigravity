# Model Selection Playbook

> Guidance for choosing models by phase and task type.
> 
> **No model is required.** These are recommendations, not requirements.

---

## Selection by Phase

### Planning & Architecture

**Recommended capabilities:**
- Extended reasoning / thinking mode
- Large context window (analyze multiple files)
- Strong at structured output (specs, plans)

**Why:** Planning requires understanding full system context and making architectural decisions.

**Examples:** Models with "thinking" or "reasoning" modes, larger context variants.

---

### Code Implementation

**Recommended capabilities:**
- Fast iteration speed
- Good at code completion
- Tool/function calling (for verification commands)

**Why:** Implementation involves many small changes with frequent verification cycles.

**Examples:** Speed-tier models, code-specialized variants.

---

### Refactoring

**Recommended capabilities:**
- Large context window (see before/after)
- Pattern recognition
- Consistent style application

**Why:** Refactoring requires maintaining consistency across large code changes.

**Examples:** Standard or long-context variants.

---

### Debugging

**Recommended capabilities:**
- Extended reasoning (hypothesis generation)
- Good at reading stack traces
- Context for error patterns

**Why:** Debugging requires hypothesis testing and pattern matching.

**Examples:** Reasoning-focused models.

---

### Code Review

**Recommended capabilities:**
- Large context (review full PR diff)
- Security pattern knowledge
- Style consistency checking

**Why:** Review requires seeing both code and context together.

**Examples:** Long-context variants.

---

## Capability Tiers

| Tier | Characteristics | Best For |
|------|-----------------|----------|
| **Fast** | Quick responses, lower cost | Implementation, iteration |
| **Standard** | Balanced speed/quality | Most tasks |
| **Reasoning** | Extended thinking, slower | Planning, debugging, architecture |
| **Long-context (200k)** | Standard base | General coding |
| **Long-context (500k)** | Larger codebase capacity | Multi-file features |
| **Massive-context (1M+)** | Whole-codebase capacity | Review, major refactoring, inline execution |

---

## Anti-Patterns

❌ **Using reasoning models for simple edits** — Overkill, slow, expensive

❌ **Using fast models for architecture** — Insufficient depth for complex decisions

❌ **Ignoring context limits** — Leads to quality degradation

❌ **Forcing a specific model** — Breaks model-agnosticism

---

## Model Switching Mid-Session

**When to switch:**
- Context is getting polluted (approaching 50% for 200k, 70% for 1M)
- Task type changes significantly (planning → implementation)
- Current model struggling with task type

> **Context Window Note:** With 1M context windows, switching specifically due to context pollution is rarely needed unless performing massive whole-project refactoring.

**How to switch:**
1. Create state snapshot
2. Update STATE.md with current position
3. Start fresh session with appropriate model
4. Load STATE.md to resume

---

## GSD Model-Agnostic Principle

GSD works with any capable LLM. The methodology compensates for model differences through:

1. **Structured plans** — Reduce ambiguity
2. **Explicit verification** — Catch errors regardless of model
3. **State persistence** — Enable model switching
4. **Fresh context** — Prevent accumulation issues

Choose models based on task needs, not methodology requirements.

---

*See PROJECT_RULES.md for canonical rules.*
*See docs/runbook.md for operational procedures.*
