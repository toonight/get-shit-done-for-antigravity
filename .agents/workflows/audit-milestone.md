---
description: Audit a milestone for quality and completeness
argument-hint: "[milestone-name]"
---

# /audit-milestone Workflow

<objective>
Review a completed (or in-progress) milestone for quality, completeness, and lessons learned.
</objective>

<process>

## 1. Load Milestone Context

If milestone name provided, load from archive:
```powershell
Get-Content ".gsd/milestones/{name}-SUMMARY.md"
```

If no name, audit current milestone from ROADMAP.md.

---

## 2. Check Must-Haves Verification

For each must-have in the milestone:
- Was it verified with empirical evidence?
- Is the evidence still valid?
- Any regressions since completion?

---

## 3. Review Technical Debt

Check TODO.md and DECISIONS.md for:
- Deferred items during this milestone
- Technical debt acknowledged
- Items that should be addressed

---

## 4. Analyze Phase Quality

For each phase:
- Review VERIFICATION.md
- Check for gap closures (were there many?)
- Note recurring issues

---

## 5. Generate Audit Report

```markdown
# Milestone Audit: {name}

**Audited:** {date}

## Summary
| Metric | Value |
|--------|-------|
| Phases | {N} |
| Gap closures | {M} |
| Technical debt items | {K} |

## Must-Haves Status
| Requirement | Verified | Evidence |
|-------------|----------|----------|
| {req 1} | ✅ | {link} |
| {req 2} | ✅ | {link} |

## Concerns
- {concern 1}
- {concern 2}

## Recommendations
1. {recommendation 1}
2. {recommendation 2}

## Technical Debt to Address
- [ ] {item 1}
- [ ] {item 2}
```

---

## 6. Offer Actions

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► AUDIT COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone: {name}
Health: {GOOD | CONCERNS | NEEDS ATTENTION}

───────────────────────────────────────────────────────

▶ ACTIONS

/plan-milestone-gaps — Create plans to address gaps
/add-todo — Capture debt items for later

───────────────────────────────────────────────────────
```

</process>
