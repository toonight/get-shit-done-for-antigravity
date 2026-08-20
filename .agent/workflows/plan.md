---
description: The Strategist — Decompose requirements into executable phases in ROADMAP.md
argument-hint: "[phase] [--research] [--skip-research] [--gaps]"
---

# /plan Workflow

<role>
You are a GSD planner orchestrator. You create executable phase plans with task breakdown, dependency analysis, and goal-backward verification.

**Core responsibilities:**
- Parse arguments and validate phase
- Handle research (unless skipped or exists)
- Create PLAN.md files with XML task structure
- Verify plans with checker logic
- Iterate until plans pass (max 3 iterations)
</role>

<objective>
Create executable phase prompts (PLAN.md files) for a roadmap phase with integrated research and verification.

**Default flow:** Research (if needed) → Plan → Verify → Done

**Why subagents:** Research and planning are the two heaviest context consumers in GSD —
research reads the codebase, planning reads the spec, roadmap, and research on top of it.
Both run in `gsd-researcher` / `gsd-planner` subagents so the orchestrator keeps the budget
it needs to run the rest of the phase. You see the flow between agents; you do not pay for
their reading.

Requires Antigravity 2.0+ (`invoke_subagent`). Older versions run inline — see
`.agents/skills/subagent-delegation/SKILL.md`.
</objective>

<context>
**Phase number:** $ARGUMENTS (optional — auto-detects next unplanned phase if not provided)

**Flags:**
- `--research` — Force re-research even if RESEARCH.md exists
- `--skip-research` — Skip research entirely, go straight to planning
- `--gaps` — Gap closure mode (reads VERIFICATION.md, skips research)

**Required files:**
- `.gsd/SPEC.md` — Must be FINALIZED (Planning Lock)
- `.gsd/ROADMAP.md` — Must have phases defined

**Delegation protocol:** `.agents/skills/subagent-delegation/SKILL.md`
**Subagents:** `.agents/agents/gsd-researcher.md`, `.agents/agents/gsd-planner.md`
</context>

<philosophy>

## Solo Developer + Claude Workflow
You are planning for ONE person (the user) and ONE implementer (Claude).
- No teams, stakeholders, ceremonies, coordination overhead
- User is the visionary/product owner
- Claude is the builder

## Plans Are Prompts
PLAN.md is NOT a document that gets transformed into a prompt.
PLAN.md IS the prompt. It contains:
- Objective (what and why)
- Context (@file references)
- Tasks (with verification criteria)
- Success criteria (measurable)

## Quality Degradation Curve

| Context Usage | Quality | State |
|---------------|---------|-------|
| 0-30% | PEAK | Thorough, comprehensive |
| 30-50% | GOOD | Confident, solid work |
| 50-70% | DEGRADING | Efficiency mode begins |
| 70%+ | POOR | Rushed, minimal |

**The rule:** Plans should complete within ~50% context. More plans, smaller scope.

## Aggressive Atomicity
Each plan: **2-3 tasks max**. No exceptions.

</philosophy>

<discovery_levels>

## Discovery Protocol

Discovery is MANDATORY unless you can prove current context exists.

**Level 0 — Skip** (pure internal work)
- ALL work follows established codebase patterns
- No new external dependencies
- Pure internal refactoring or feature extension

**Level 1 — Quick Verification** (2-5 min)
- Single known library, confirming syntax/version
- Low-risk decision (easily changed later)
- Action: Quick web search, no RESEARCH.md needed

**Level 1.5 — Discovery** (5-15 min)
- Quick library/option comparison (A vs B)
- Low-to-medium risk, focused question
- Action: Create DISCOVERY.md using `.gsd/templates/discovery.md` template

**Level 2 — Standard Research** (15-30 min)
- Choosing between 2-3 options
- New external integration (API, service)
- Medium-risk decision
- Action: Create RESEARCH.md with findings

**Level 3 — Deep Dive** (1+ hour)
- Architectural decision with long-term impact
- Novel problem without clear patterns
- High-risk, hard to change later
- Action: Full research with RESEARCH.md

</discovery_levels>

<process>

## 1. Validate Environment (Planning Lock)

**PowerShell:**
```powershell
# Check SPEC.md exists and is finalized
$spec = Get-Content ".gsd/SPEC.md" -Raw
if ($spec -notmatch "FINALIZED") {
    Write-Error "SPEC.md must be FINALIZED before planning"
    exit
}
```

**Bash:**
```bash
# Check SPEC.md exists and is finalized
if ! grep -q "FINALIZED" ".gsd/SPEC.md"; then
    echo "Error: SPEC.md must be FINALIZED before planning" >&2
    exit 1
fi
```

**If not finalized:** Error — user must complete SPEC.md first.

---

## 2. Parse and Normalize Arguments

Extract from $ARGUMENTS:
- Phase number (integer)
- `--research` flag
- `--skip-research` flag
- `--gaps` flag

**If no phase number:** Detect next unplanned phase from ROADMAP.md.

---

## 3. Validate Phase

**PowerShell:**
```powershell
Select-String -Path ".gsd/ROADMAP.md" -Pattern "Phase $PHASE:"
```

**Bash:**
```bash
grep "Phase $PHASE:" ".gsd/ROADMAP.md"
```

**If not found:** Error with available phases.
**If found:** Extract phase name and description.

---

## 4. Ensure Phase Directory

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

## 5. Handle Research

**If `--gaps` flag:** Skip research (gap closure uses VERIFICATION.md).

**If `--skip-research` flag:** Skip to step 6.

**Check for existing research:**
**PowerShell:**
```powershell
Test-Path "$PHASE_DIR/RESEARCH.md"
```

**Bash:**
```bash
test -f "$PHASE_DIR/RESEARCH.md"
```

**If RESEARCH.md exists AND `--research` flag NOT set:**
- Display: `Using existing research: $PHASE_DIR/RESEARCH.md`
- Skip to step 6

**If research needed:**

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► RESEARCHING PHASE {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Delegated mode** (`invoke_subagent` available): invoke `gsd-researcher` with workspace mode
`share`:

```
mode: research
phase: {N}
level: {1|2|3 from <discovery_levels>}
questions:
  - {question 1}
  - {question 2}

Write findings to .gsd/phases/{phase}/RESEARCH.md.
Return the compact digest from your Return Contract — nothing else.
```

Read only the returned digest. The RESEARCH.md itself is for the planner to read, not you.

**Inline mode:** perform research based on discovery level (see `<discovery_levels>`) and
create `$PHASE_DIR/RESEARCH.md` with findings.

---

## 6. Create Plans

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► PLANNING PHASE {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Delegated mode** (`invoke_subagent` available): invoke `gsd-planner` with workspace mode
`inherit`:

```
phase: {N}
mode: {standard|gaps}
research_path: .gsd/phases/{phase}/RESEARCH.md   {omit if none}

Write plans from .gsd/templates/PLAN.md. 2-3 tasks each, wave + depends_on in frontmatter.
Self-check with plan-checker before returning.
Return the compact index from your Return Contract — nothing else.
```

The planner runs its own checker loop, so **skip step 7** when it returns `status: complete`.
Steps 6a-6c below describe what the planner does; run them yourself only in inline mode.

---

### 6a. Gather Context
Load:
- `.gsd/SPEC.md` — Requirements
- `.gsd/REQUIREMENTS.md` — Formal requirements tracking (if exists)
- `.gsd/ROADMAP.md` — Phase description
- `$PHASE_DIR/RESEARCH.md` — If exists
- `.gsd/ARCHITECTURE.md` — If exists

### 6b. Decompose into Tasks
For the phase goal:
1. Identify all deliverables
2. Break into atomic tasks (2-3 per plan)
3. Determine dependencies between tasks
4. Assign execution waves

### 6c. Write PLAN.md Files

Create `$PHASE_DIR/{N}-PLAN.md`:

```markdown
---
phase: {N}
plan: 1
wave: 1
---

# Plan {N}.1: {Plan Name}

## Objective
{What this plan delivers and why}

## Context
- .gsd/SPEC.md
- .gsd/ARCHITECTURE.md
- {relevant source files}

## Tasks

<task type="auto">
  <name>{Task name}</name>
  <files>{exact file paths}</files>
  <action>
    {Specific implementation instructions}
    - What to do
    - What to avoid and WHY
  </action>
  <verify>{Command to prove task complete}</verify>
  <done>{Measurable acceptance criteria}</done>
</task>

<task type="auto">
  ...
</task>

## Success Criteria
- [ ] {Measurable outcome 1}
- [ ] {Measurable outcome 2}
```

---

## 7. Verify Plans (Checker Logic)

For each plan, verify:
- [ ] All files specified exist or will be created
- [ ] Actions are specific (no "implement X")
- [ ] Verify commands are executable
- [ ] Done criteria are measurable
- [ ] Context references exist
- [ ] Tests are meaningful (see Test Quality Rules below)

**If issues found:** Fix and re-verify (max 3 iterations).

### Test Quality Rules

Tests must verify real behavior, not just pass. Reject plans with tests that:

| Anti-pattern | Example | Fix |
|-------------|---------|-----|
| **Mock everything** | Mocking the DB then asserting the mock was called | Use real DB or integration test |
| **Tautological assert** | `assert mock.called` with no behavior check | Assert actual output or side effect |
| **Always-pass test** | `assert True` or `assert response is not None` | Assert specific expected values |
| **Testing the framework** | Asserting that Express returns 200 on a stub | Test your logic, not the framework |
| **No negative cases** | Only testing the happy path | Include at least one failure/edge case |

**Rule:** Every `<verify>` command must test the *actual behavior* of the code, not just that it runs without errors. If a test would still pass with the implementation deleted, it is not a valid test.

---

## 8. Update State

Update `.gsd/STATE.md`:
```markdown
## Current Position
- **Phase**: {N}
- **Task**: Planning complete
- **Status**: Ready for execution

## Next Steps
1. /execute {N}
```

---

## 9. Commit Plans

```bash
git add .gsd/phases/$PHASE/
git add .gsd/STATE.md
git commit -m "docs(phase-$PHASE): create execution plans"
```

---

## 10. Offer Next Steps

</process>

<offer_next>

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► PHASE {N} PLANNED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{X} plans created across {Y} waves

Plans:
• {N}.1: {Name} (wave 1)
• {N}.2: {Name} (wave 1)
• {N}.3: {Name} (wave 2)

───────────────────────────────────────────────────────

▶ Next Up

/execute {N} — run all plans

───────────────────────────────────────────────────────
```

</offer_next>

<task_types>

| Type | Use For | Autonomy |
|------|---------|----------|
| `auto` | Everything Claude can do independently | Fully autonomous |
| `checkpoint:human-verify` | Visual/functional verification | Pauses for user |
| `checkpoint:decision` | Implementation choices | Pauses for user |

**Automation-first rule:** If Claude CAN do it, Claude MUST do it. Checkpoints are for verification AFTER automation.

</task_types>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/map` | Run before /plan to get codebase context |
| `/execute` | Runs PLAN.md files created by /plan |
| `/verify` | Validates executed plans |

### Skills
| Skill | Purpose |
|-------|---------|
| `planner` | Detailed planning methodology |
| `plan-checker` | Validates plans before execution |
</related>
