---
description: The Engineer — Execute a specific phase with focused context
argument-hint: "<phase-number> [--gaps-only]"
---

# /execute Workflow

<role>
You are a GSD executor orchestrator. You manage wave-based parallel execution of phase plans.

**Core responsibilities:**
- Validate phase exists and has plans
- Discover and group plans by execution wave
- Spawn focused execution for each plan
- Verify phase goal after all plans complete
- Update roadmap and state on completion
</role>

<objective>
Execute all plans in a phase using wave-based parallel execution (or inline execution for larger context windows).

Orchestrator stays lean: discover plans, analyze dependencies, group into waves, execute sequentially within waves, verify against phase goal.

**Context budget:** 
- 200k baseline: ~15% orchestrator, strictly fresh context per plan execution.
- 500k context: ~10% orchestrator, inline execution supported for small phases.
- 1M+ context: ~8% orchestrator, inline execution preferred when usage is under 30%.
</objective>

<context>
**Phase:** $ARGUMENTS (required - phase number to execute)

**Flags:**
- `--gaps-only` — Execute only gap closure plans (created by `/verify` when issues found)

**Required files:**
- `.gsd/ROADMAP.md` — Phase definitions
- `.gsd/STATE.md` — Current position
- `.gsd/phases/{phase}/` — Phase directory with PLAN.md files
</context>

<process>

## 1. Validate Environment

**PowerShell:**
```powershell
Test-Path ".gsd/ROADMAP.md"
Test-Path ".gsd/STATE.md"
```

**Bash:**
```bash
test -f ".gsd/ROADMAP.md"
test -f ".gsd/STATE.md"
```

**If not found:** Error — user should run `/plan` first.

---

## 2. Validate Phase Exists

**PowerShell:**
```powershell
# Check phase exists in roadmap
Select-String -Path ".gsd/ROADMAP.md" -Pattern "Phase $PHASE:"
```

**Bash:**
```bash
# Check phase exists in roadmap
grep "Phase $PHASE:" ".gsd/ROADMAP.md"
```

**If not found:** Error with available phases from ROADMAP.md.

---

## 3. Ensure Phase Directory Exists

**PowerShell:**
```powershell
$PHASE_DIR = ".gsd/phases/$PHASE"
if (-not (Test-Path $PHASE_DIR)) {
    New-Item -ItemType Directory -Path $PHASE_DIR
}
```

**Bash:**
```bash
PHASE_DIR=".gsd/phases/$PHASE"
mkdir -p "$PHASE_DIR"
```

---

## 4. Discover Plans

**PowerShell:**
```powershell
Get-ChildItem "$PHASE_DIR/*-PLAN.md"
```

**Bash:**
```bash
ls "$PHASE_DIR"/*-PLAN.md 2>/dev/null
```

**Check for existing summaries** (completed plans):

**PowerShell:**
```powershell
Get-ChildItem "$PHASE_DIR/*-SUMMARY.md"
```

**Bash:**
```bash
ls "$PHASE_DIR"/*-SUMMARY.md 2>/dev/null
```

**Build list of incomplete plans** (PLAN without matching SUMMARY).

**If `--gaps-only`:** Filter to only plans with `gap_closure: true` in frontmatter.

**If no incomplete plans found:** Phase already complete, skip to step 8.

---

## 5. Group Plans by Wave

Read `wave` field from each plan's frontmatter:

```yaml
---
phase: 1
plan: 2
wave: 1
---
```

**Group plans by wave number.** Lower waves execute first.

> **Context Window Adaptation:** 
> If your model has a 500k or 1M context window and the phase is small, consider merging adjacent small waves into a single wave to minimize overhead.

Display wave structure:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► EXECUTING PHASE {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wave 1: {plan-1}, {plan-2}
Wave 2: {plan-3}

{X} plans across {Y} waves
```

---

## 6. Execute Waves

For each wave in order:

### 6a. Execute Plans in Wave
For each plan in the current wave:

> **Execution Strategy per Context Size:**
> - **200k (Default):** Spawn a fresh subagent executor for each plan.
> - **500k/1M:** If active context usage is < 30%, you may choose to execute the plan INLINE instead of spawning a subagent.

1. **Load plan context** — Read only the PLAN.md file
2. **Execute tasks** — Follow `<task>` blocks in order
3. **Verify each task** — Run `<verify>` commands
4. **Commit per task:**
   ```bash
   git add -A
   git commit -m "feat(phase-{N}): {task-name}"
   ```
5. **Create SUMMARY.md** — Document what was done

### 6b. Verify Wave Complete
Check all plans in wave have SUMMARY.md files.

### 6c. Proceed to Next Wave
Only after current wave fully completes.

---

## 7. Verify Phase Goal

After all waves complete:

1. **Read phase goal** from ROADMAP.md
2. **Check must-haves** against actual codebase (not SUMMARY claims)
3. **Run verification commands** specified in phase

**Create VERIFICATION.md:**
```markdown
## Phase {N} Verification

### Must-Haves
- [x] Must-have 1 — VERIFIED (evidence: ...)
- [ ] Must-have 2 — FAILED (reason: ...)

### Verdict: PASS / FAIL
```

**Route by verdict:**
- `PASS` → Continue to step 8
- `FAIL` → Create gap closure plans, offer `/execute {N} --gaps-only`

---

## 8. Update Roadmap and State

**Update ROADMAP.md:**
```markdown
### Phase {N}: {Name}
**Status**: ✅ Complete
```

**Update STATE.md:**
```markdown
## Current Position
- **Phase**: {N} (completed)
- **Task**: All tasks complete
- **Status**: Verified

## Last Session Summary
Phase {N} executed successfully. {X} plans, {Y} tasks completed.

## Next Steps
1. Proceed to Phase {N+1}
```

---

## 9. Commit Phase Completion

```bash
git add .gsd/ROADMAP.md .gsd/STATE.md
git commit -m "docs(phase-{N}): complete {phase-name}"
```

---

## 10. Offer Next Steps

</process>

<offer_next>
Output based on status:

**Route A: Phase complete, more phases remain**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► PHASE {N} COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X} plans executed
Goal verified ✓

───────────────────────────────────────────────────────

▶ Next Up
Phase {N+1}: {Name}

/plan {N+1}  — create execution plans
/execute {N+1} — execute directly (if plans exist)

───────────────────────────────────────────────────────
```

**Route B: All phases complete**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► MILESTONE COMPLETE 🎉
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All phases completed and verified.

───────────────────────────────────────────────────────
```

**Route C: Gaps found**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► PHASE {N} GAPS FOUND ⚠
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X}/{Y} must-haves verified
Gap closure plans created.

/execute {N} --gaps-only — execute fix plans

───────────────────────────────────────────────────────
```
</offer_next>

<context_hygiene>
**After 3 failed debugging attempts:**
1. Stop current approach
2. Document to `.gsd/STATE.md` what was tried
3. Recommend `/pause` for fresh session
</context_hygiene>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/plan` | Creates PLAN.md files that /execute runs |
| `/verify` | Validates work after /execute completes |
| `/debug` | Use when tasks fail verification |
| `/pause` | Use after 3 debugging failures |

### Skills
| Skill | Purpose |
|-------|---------|
| `executor` | Detailed execution protocol |
| `context-health-monitor` | 3-strike rule enforcement |
| `empirical-validation` | Verification requirements |
</related>
