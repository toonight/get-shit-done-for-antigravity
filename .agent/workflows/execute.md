---
description: The Engineer — Execute a specific phase with focused context
argument-hint: "<phase-number> [--gaps-only]"
---

# /execute Workflow

<role>
You are a GSD executor orchestrator. You do not execute plans yourself — you delegate each
plan to a `gsd-executor` subagent and route the results.

**Core responsibilities:**
- Validate phase exists and has plans
- Discover and group plans by execution wave
- Delegate each plan to a `gsd-executor` subagent with a clean context
- Verify phase goal after all plans complete
- Update roadmap and state on completion
</role>

<objective>
Execute all plans in a phase using wave-based execution, one subagent per plan.

Orchestrator stays lean: discover plans, analyze dependencies, group into waves, delegate,
read compact results, verify against phase goal.

**Context budget:** ~15% orchestrator. Each plan executes in its own subagent context.
</objective>

<context>
**Phase:** $ARGUMENTS (required - phase number to execute)

**Flags:**
- `--gaps-only` — Execute only gap closure plans (created by `/verify` when issues found)
- `--inline` — Force inline execution without subagents (debugging escape hatch)

**Required files:**
- `.gsd/ROADMAP.md` — Phase definitions
- `.gsd/STATE.md` — Current position
- `.gsd/phases/{phase}/` — Phase directory with PLAN.md files

**Delegation protocol:** `.agents/skills/subagent-delegation/SKILL.md`
**Subagent:** `.agents/agents/gsd-executor.md`
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

### 6a. Check Delegation Capability

Look for `invoke_subagent` in your available tools.

| Result | Path |
|--------|------|
| Available, and no `--inline` flag | **Delegated mode** — 6b |
| Unavailable, or `--inline` passed | **Inline mode** — 6e |

---

### 6b. Delegate Each Plan in the Wave

For each wave in order, invoke one `gsd-executor` subagent per plan.

**Workspace mode:**

| Plans in wave | Mode | Reason |
|---------------|------|--------|
| 1 | `inherit` | Nothing to collide with |
| 2+ | `branch` | Concurrent writers need isolated worktrees |

**Invocation prompt** — paths only, never file contents:

```
plan_path: .gsd/phases/{phase}/{n}-PLAN.md
phase: {N}
completed_tasks: {only on continuation, from a prior checkpoint}

Read .gsd/STATE.md and PROJECT_RULES.md first.
Execute this plan only. Commit per task. Write your SUMMARY.md.
Return the compact block from your Return Contract — nothing else.
```

Constraints from `.gsd/STATE.md` that bound the work (accepted decisions, known blockers)
go in the prompt as plain lines. The subagent cannot see this conversation.

See `.agents/skills/subagent-delegation/SKILL.md` for the full protocol.

---

### 6c. Route Each Result

Each subagent returns a compact block. **Do not read the SUMMARY.md files** — the block is
enough to route, and reading them re-imports the context delegation just saved.

| `status` | Action |
|----------|--------|
| `complete` | Record commits, continue |
| `checkpoint` | Present the checkpoint to the user, stop the wave, resume with a fresh subagent carrying `completed_tasks` |
| `blocked` | Report the blocker, stop the wave, do not start the next one |
| no result / subagent died | Report as failure and stop — do not silently redo the work inline |

---

### 6d. Close the Wave

1. If the wave ran in `branch` mode, merge each worktree back and resolve conflicts
2. Confirm every plan in the wave has a SUMMARY.md on disk
3. Only then start the next wave

---

### 6e. Inline Fallback (Antigravity 1.x)

Announce degraded mode once:

```
⚠️  Subagent delegation unavailable (requires Antigravity 2.0+)
    Running inline — context will fill faster.
    Recommended: one plan per session, /pause between plans.
```

Then, for **one plan only** — never a full wave:

1. **Load plan context** — Read only the PLAN.md file
2. **Execute tasks** — Follow `<task>` blocks in order
3. **Verify each task** — Run `<verify>` commands
4. **Commit per task** — separate commands, never chained with `&&`:

   **PowerShell:**
   ```powershell
   git add -A
   git commit -m "feat(phase-{N}): {task-name}"
   git log -1 --oneline
   ```

   **Bash:**
   ```bash
   git add -A
   git commit -m "feat(phase-{N}): {task-name}"
   git log -1 --oneline
   ```

   Read the `git log` output and confirm it names this task. A commit you did not verify did
   not happen.
5. **Create SUMMARY.md** — Document what was done
6. **Stop and offer `/pause`** so the next plan starts on a fresh context

---

## 7. Verify Phase Goal

After all waves complete.

**Delegated mode:** invoke `gsd-verifier` with `phase: {N}` and workspace mode `share`. It
returns a compact verdict. Skip to "Route by verdict" — the orchestrator does not re-verify.

The verifier's independence is the point: it never saw the implementation, so it cannot
inherit the executors' assumptions about their own work.

**Inline mode:**

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

**Update REQUIREMENTS.md** (if exists):
- Cross-reference completed tasks with requirement IDs
- Mark requirements satisfied by this phase as `In Progress` or `Complete`
- Update the traceability matrix with plan references

---

## 9. Commit Phase Completion

```bash
git add .gsd/ROADMAP.md .gsd/STATE.md .gsd/REQUIREMENTS.md
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
