# GSD for Antigravity

> **Get Shit Done** — A spec-driven, context-engineered development methodology adapted for Google Antigravity.

[![Based on GSD](https://img.shields.io/badge/based%20on-GSD-blue)](https://github.com/glittercowboy/get-shit-done)

---

## Why This Exists

Vibecoding has a bad reputation. You describe what you want, AI generates code, and you get inconsistent garbage that falls apart at scale.

GSD fixes that. It's the **context engineering layer** that makes AI coding reliable. Describe your idea, let the system extract everything it needs to know, and let the AI get to work.

**No enterprise roleplay.** No sprint ceremonies, story points, stakeholder syncs, or Jira workflows. Just an incredibly effective system for building cool stuff consistently.

The complexity is in the system, not in your workflow.

---

## Who This Is For

People who want to describe what they want and have it built correctly — without pretending they're running a 50-person engineering org.

- Solo developers using AI coding assistants
- Small teams who want structure without overhead
- Anyone tired of AI generating inconsistent garbage

---

## 🚀 Getting Started

**PowerShell (Windows):**
```powershell
# Open your project
cd your-project

# Clone the GSD template
git clone https://github.com/toonight/get-shit-done-for-antigravity.git gsd-template

# Copy to your project
Copy-Item -Recurse gsd-template\.agent .\
Copy-Item -Recurse gsd-template\.gemini .\
Copy-Item -Recurse gsd-template\.gsd .\

# Clean up
Remove-Item -Recurse -Force gsd-template
```

**Bash (Linux/Mac):**
```bash
# open your project
cd your-project

# Clone the GSD template
git clone https://github.com/toonight/get-shit-done-for-antigravity.git gsd-template

# Copy to your project
cp -r gsd-template/.agent ./
cp -r gsd-template/.gemini ./
cp -r gsd-template/.gsd ./

# Clean up
rm -rf gsd-template
```

Then run `/new-project` and follow the prompts.

---

## How It Works

### 1. Initialize → Question → Spec
```
/new-project → Deep questioning → SPEC.md (finalized)
```

### 2. Discuss (Optional) → Context
```
/discuss-phase 1 → Clarify scope → DECISIONS.md
```

### 3. Plan → Research → Tasks
```
/plan 1 → Discovery → PLAN.md with XML tasks
```

### 4. Execute → Verify → Commit
```
/execute 1 → Wave execution → Atomic commits
/verify 1 → Must-haves check → Evidence captured
```

### 5. Repeat
```
/discuss-phase 2 → /plan 2 → /execute 2 → ...
/complete-milestone → Next milestone
```

---

## Why It Works

### Context Engineering

The AI is incredibly powerful *if* you give it the context it needs. Most people don't.

GSD handles it for you:

| File | What it does |
|------|--------------|
| `SPEC.md` | Project vision, always loaded |
| `ARCHITECTURE.md` | System understanding |
| `ROADMAP.md` | Where you're going, what's done |
| `STATE.md` | Decisions, blockers, position — memory across sessions |
| `PLAN.md` | Atomic tasks with XML structure, verification steps |
| `SUMMARY.md` | What happened, what changed |

Size limits based on where AI quality degrades. Stay under, get consistent excellence.

### XML Prompt Formatting

Every plan is structured XML optimized for AI execution:

```xml
<task type="auto">
  <name>Create login endpoint</name>
  <files>src/app/api/auth/login/route.ts</files>
  <action>
    Use jose for JWT (not jsonwebtoken - CommonJS issues).
    Validate credentials against users table.
    Return httpOnly cookie on success.
  </action>
  <verify>curl -X POST localhost:3000/api/auth/login returns 200 + Set-Cookie</verify>
  <done>Valid credentials return cookie, invalid return 401</done>
</task>
```

Precise instructions. No guessing. Verification built in.

### Wave-Based Execution

Plans are grouped into waves based on dependencies:

| Wave | Plans | Parallelization |
|------|-------|-----------------|
| 1 | Foundation tasks | Run together |
| 2 | Depends on Wave 1 | Wait, then run together |
| 3 | Depends on Wave 2 | Wait, then run together |

Each executor gets fresh context. Your main session stays fast.

### Atomic Git Commits

Each task gets its own commit immediately after completion:

```bash
abc123f feat(phase-1): create login endpoint
def456g feat(phase-1): add password validation
hij789k feat(phase-1): implement JWT cookie handling
```

**Benefits:** 
- Git bisect finds exact failing task
- Each task independently revertable
- Clear history for AI in future sessions

### Empirical Verification

No "trust me, it works." Every verification produces evidence:

| Change Type   | Evidence Required |
|--------------|-------------------|
| API endpoint  | curl output        |
| UI change     | Screenshot         |
| Build         | Command output     |
| Tests         | Test results       |

---

## 🎮 Commands (25 Total)

### Core Workflow
| Command | Purpose |
|---------|---------|
| `/map` | Analyze codebase → ARCHITECTURE.md |
| `/plan [N]` | Create PLAN.md files for phase N |
| `/execute [N]` | Wave-based execution with atomic commits |
| `/verify [N]` | Must-haves validation with proof |
| `/debug [desc]` | Systematic debugging (3-strike rule) |

### Project Setup
| Command | Purpose |
|---------|---------|
| `/new-project` | Deep questioning → SPEC.md |
| `/new-milestone` | Create milestone with phases |
| `/complete-milestone` | Archive completed milestone |
| `/audit-milestone` | Review milestone quality |

### Phase Management
| Command | Purpose |
|---------|---------|
| `/add-phase` | Add phase to end of roadmap |
| `/insert-phase` | Insert phase (renumbers) |
| `/remove-phase` | Remove phase (safety checks) |
| `/discuss-phase` | Clarify scope before planning |
| `/research-phase` | Deep technical research |
| `/list-phase-assumptions` | Surface planning assumptions |
| `/plan-milestone-gaps` | Create gap closure plans |

### Navigation & State
| Command | Purpose |
|---------|---------|
| `/progress` | Show current position |
| `/pause` | Save state for session handoff |
| `/resume` | Restore from last session |
| `/add-todo` | Quick capture idea |
| `/check-todos` | List pending items |

---

## 💡 Daily Workflow

**Without GSD:** "Add a feature" → Inconsistent code → Bugs → Debug loop → Frustration

**With GSD:** "Add a feature" → SPEC → Plan → Atomic execution → Verification → ✅ Done

### Typical Session

```
/resume              ← Load context from last session
/progress            ← See where you left off
/discuss-phase 2     ← Clarify requirements (optional)
/plan 2              ← Plan next phase
/execute 2           ← Implement with atomic commits
/verify 2            ← Prove it works (screenshots, tests)
/pause               ← Save state for later
```

### Key Principle

GSD forces **planning before coding**. Claude can't write code until `SPEC.md` says `FINALIZED`. This prevents building the wrong thing.

---

## 🔒 Core Rules

| Rule | Why It Matters |
|------|----------------|
| 🔒 **Planning Lock** | No code until SPEC.md is FINALIZED — prevents building wrong thing |
| 💾 **State Persistence** | Update STATE.md after every task — memory across sessions |
| 🧹 **Context Hygiene** | 3 failures → state dump → fresh session — prevents circular debugging |
| ✅ **Empirical Validation** | Proof required — no "it should work" |

---

## 🌍 Cross-Platform Support

All workflow files include **dual syntax** — both PowerShell and Bash commands:

- **Windows users:** Use the PowerShell blocks
- **Linux/Mac users:** Use the Bash blocks (some may require `jq` for JSON parsing)

**Note:** Git commands (`git add`, `git commit`, `git tag`) are cross-platform and work identically on all systems.

---

## 🤖 Multi-Model Support

GSD is **model-agnostic**. Use any LLM that works in your environment.

### Canonical Rules

All rules live in [PROJECT_RULES.md](PROJECT_RULES.md) — the single source of truth.

### Optional Adapters

Model-specific enhancements (optional, never required):

```
adapters/
├── CLAUDE.md    # Extended thinking, effort levels
├── GEMINI.md    # Flash vs Pro selection
└── GPT_OSS.md   # Function calling, context handling
```

### Model Selection by Phase

| Phase | Recommended | Why |
|-------|-------------|-----|
| Planning | Reasoning models | Complex decisions |
| Implementation | Fast models | Iteration speed |
| Debugging | Reasoning models | Hypothesis testing |
| Review | Long-context models | Full diff analysis |

See [docs/model-selection-playbook.md](docs/model-selection-playbook.md) for detailed guidance.

---

## 🔍 Search-First Mode

**Principle:** Search before reading files completely.

### Why?
- Reduces context pollution
- Faster codebase understanding
- Prevents reading irrelevant code

### Setup (Optional)

**PowerShell:**
```powershell
.\scripts\setup_search.ps1    # Checks for ripgrep/fd
.\scripts\search_repo.ps1 "pattern"  # Search wrapper
```

**Bash:**
```bash
./scripts/setup_search.sh     # Checks for ripgrep/fd
./scripts/search_repo.sh "pattern"   # Search wrapper
```

**No installation required** — falls back to built-in tools (Select-String/grep).

### Workflow

1. **Define question** — What are you looking for?
2. **Search first** — `.\scripts\search_repo.ps1 "keyword"`
3. **Evaluate results** — Which files matter?
4. **Targeted read** — Only read relevant sections

See [.agent/skills/context-fetch/SKILL.md](.agent/skills/context-fetch/SKILL.md) for the full skill.

---

## 📁 File Structure

```
PROJECT_RULES.md          # ← Canonical rules (model-agnostic)
GSD-STYLE.md              # Complete style guide

.agent/
├── workflows/            # 25 slash commands
└── skills/               # 9 agent specializations (incl. context-fetch)

.gemini/
└── GEMINI.md             # Gemini integration

.gsd/
├── SPEC.md               # ← START HERE (finalize first)
├── ROADMAP.md            # Phases and progress
├── STATE.md              # Session memory
├── ARCHITECTURE.md       # System design (/map output)
├── STACK.md              # Tech inventory
├── DECISIONS.md          # Architecture Decision Records
├── JOURNAL.md            # Session log
├── TODO.md               # Quick capture
├── templates/            # Document templates
└── examples/             # Usage walkthroughs

adapters/                 # Optional model-specific enhancements
├── CLAUDE.md
├── GEMINI.md
└── GPT_OSS.md

docs/                     # Operational documentation
├── model-selection-playbook.md
└── runbook.md

scripts/                  # Utility scripts
├── validate-*.ps1/.sh    # Structure validators
├── setup_search.ps1/.sh  # Search tool setup
└── search_repo.ps1/.sh   # Search wrapper

model_capabilities.yaml   # Optional capability registry
```

---

## 🧪 Testing

Run validation scripts to verify GSD structure:

**PowerShell:**
```powershell
.\scripts\validate-all.ps1      # Run all validators
.\scripts\validate-workflows.ps1  # Workflows only
.\scripts\validate-skills.ps1     # Skills only
```

**Bash:**
```bash
./scripts/validate-all.sh      # Run all validators
./scripts/validate-workflows.sh  # Workflows only
./scripts/validate-skills.sh     # Skills only
```

---

## 📚 Documentation

- [PROJECT_RULES.md](PROJECT_RULES.md) — Canonical model-agnostic rules
- [GSD-STYLE.md](GSD-STYLE.md) — Complete style and conventions guide
- [docs/model-selection-playbook.md](docs/model-selection-playbook.md) — Model selection guidance
- [docs/runbook.md](docs/runbook.md) — Operational procedures
- [Examples](.gsd/examples/) — Usage walkthroughs and quick reference
- [Templates](.gsd/templates/) — Document templates for plans, verification, etc.

---

## 🧠 Philosophy

- **Plan before building** — SPEC.md matters more than you think
- **Fresh context > polluted context** — State dumps prevent hallucinations
- **Proof over trust** — Screenshots and command outputs, not "looks right"
- **Aggressive atomicity** — 2-3 tasks per plan, atomic commits
- **Search before reading** — Don't load files blindly
- **Model-agnostic** — Works with any capable LLM
- **No enterprise theater** — Solo dev + AI workflow only

---

*Adapted from [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done) for Google Antigravity*