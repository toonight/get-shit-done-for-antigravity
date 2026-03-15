---
description: Deep technical research for a phase
argument-hint: "<phase-number> [--level 1|2|3]"
---

# /research-phase Workflow

<objective>
Conduct technical research to inform planning decisions for a phase.
</objective>

<discovery_levels>
## Discovery Levels

| Level | Time | Use When |
|-------|------|----------|
| 0 | 0 min | Already know, just doing it |
| 1 | 2-5 min | Single library, confirming syntax |
| 2 | 15-30 min | Choosing between options, new integration |
| 3 | 1+ hour | Architectural decision, novel problem |

**Default:** Level 2 unless specified.
</discovery_levels>

<process>

## 1. Load Phase Context

Read:
- Phase objective from ROADMAP.md
- Relevant ARCHITECTURE.md sections
- STACK.md for current technologies

---

## 2. Identify Research Questions

What needs to be understood before planning?

```markdown
## Research Questions

1. {Technical question 1}
2. {Technical question 2}
3. {Integration question}
```

---

## 3. Conduct Research

Based on discovery level:

**Level 1:** Quick verification
- Check official docs
- Confirm API/syntax

**Level 2:** Comparison research
- Compare 2-3 options
- Evaluate trade-offs
- Make recommendation

**Level 3:** Deep dive
- Prototype if needed
- Research edge cases
- Document unknowns

---

## 4. Generate RESEARCH.md

Create `.gsd/phases/{N}/RESEARCH.md`:

```markdown
---
phase: {N}
level: {1|2|3}
researched_at: {date}
---

# Phase {N} Research

## Questions Investigated
1. {question}
2. {question}

## Findings

### {Topic 1}
{What was learned}

**Sources:**
- {URL}

**Recommendation:** {what to do}

### {Topic 2}
...

## Decisions Made
| Decision | Choice | Rationale |
|----------|--------|-----------|
| {decision} | {choice} | {why} |

## Patterns to Follow
- {pattern 1}
- {pattern 2}

## Anti-Patterns to Avoid
- {anti-pattern}: {why}

## Dependencies Identified
| Package | Version | Purpose |
|---------|---------|---------|
| {pkg} | {ver} | {why} |

## Risks
- {risk}: {mitigation}

## Ready for Planning
- [x] Questions answered
- [x] Approach selected
- [x] Dependencies identified
```

---

## 5. Commit Research

```powershell
git add .gsd/phases/{N}/RESEARCH.md
git commit -m "docs(phase-{N}): research complete"
```

---

## 6. Offer Next Steps

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► RESEARCH COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase {N}: {name}
Level: {level}

Key findings:
• {finding 1}
• {finding 2}

───────────────────────────────────────────────────────

▶ NEXT

/plan {N} — Create plans informed by research

───────────────────────────────────────────────────────
```

</process>
