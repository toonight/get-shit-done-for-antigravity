---
description: Initialize a new GSD project with all required files
---

# /new-project Workflow

<objective>
Set up a new project with all GSD documentation and configuration files.
</objective>

<process>

## 1. Gather Project Information

Ask for:
- **Project name** — What is the project called?
- **Vision** — What does it do? (one sentence)
- **Primary goal** — What's the first thing it needs to accomplish?

---

## 2. Create Directory Structure

```powershell
# Create .gsd/ directory with all required files
New-Item -ItemType Directory -Force -Path ".gsd", ".gsd/phases", ".gsd/templates", ".gsd/examples"

# Create .agent/ structure
New-Item -ItemType Directory -Force -Path ".agent/workflows", ".agent/skills"

# Create .gemini/
New-Item -ItemType Directory -Force -Path ".gemini"
```

---

## 3. Generate SPEC.md

```markdown
# SPEC.md — Project Specification

> **Status**: `DRAFT`

## Vision
{User-provided vision}

## Goals
1. {Primary goal}
2. TBD
3. TBD

## Non-Goals
- TBD

## Constraints
- TBD

## Success Criteria
- [ ] TBD
```

---

## 4. Generate Initial Documentation

Create empty/template versions of:
- `.gsd/ROADMAP.md`
- `.gsd/STATE.md`
- `.gsd/ARCHITECTURE.md`
- `.gsd/STACK.md`
- `.gsd/DECISIONS.md`
- `.gsd/JOURNAL.md`
- `.gsd/TODO.md`

---

## 5. Generate GEMINI.md Rules

Copy standard GSD rules for Antigravity enforcement.

---

## 6. Initialize Git (Optional)

```powershell
git init
git add -A
git commit -m "chore: initialize GSD project"
```

---

## 7. Display Next Steps

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► PROJECT INITIALIZED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project: {name}

Files created:
• .gsd/ (7 docs)
• .agent/ (workflows & skills)
• .gemini/GEMINI.md

───────────────────────────────────────────────────────

▶ NEXT STEPS

1. Edit .gsd/SPEC.md
   - Add goals and constraints
   - Mark as FINALIZED when ready

2. /plan 1
   Create Phase 1 plans

───────────────────────────────────────────────────────
```

</process>
