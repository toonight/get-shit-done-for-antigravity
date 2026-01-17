# GSD for Antigravity

> **Get Shit Done** — A spec-driven, context-engineered development methodology adapted for Google Antigravity.

[![Based on GSD](https://img.shields.io/badge/based%20on-GSD-blue)](https://github.com/glittercowboy/get-shit-done)

---

## 🚀 Installation

### Clone and Copy

```powershell
# Clone the GSD template
git clone https://github.com/toonight/get-shit-done-for-antigravity.git gsd-template

# Copy to your project
cd your-project
Copy-Item -Recurse gsd-template\.agent .\
Copy-Item -Recurse gsd-template\.gemini .\
Copy-Item -Recurse gsd-template\.gsd .\

# Clean up
Remove-Item -Recurse -Force gsd-template
```

---

## 📋 Quick Start

```
1. /new-project              → Initialize GSD in your project
2. Edit .gsd/SPEC.md         → Define vision, mark FINALIZED
3. /new-milestone            → Create milestone with phases
4. /plan 1                   → Create Phase 1 plans
5. /execute 1                → Implement Phase 1
6. /verify 1                 → Confirm it works
7. Repeat for each phase
```

---

## 🎮 Commands (22 Total)

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
| `/new-project` | Initialize GSD in new project |
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

## 🔒 Core Rules

| Rule | Enforcement |
|------|-------------|
| 🔒 Planning Lock | No code until SPEC.md is FINALIZED |
| 💾 State Persistence | Update STATE.md after every task |
| 🧹 Context Hygiene | 3 failures → state dump → fresh session |
| ✅ Empirical Validation | Proof required, no "it should work" |

---

## 📁 File Structure

```
.agent/
├── workflows/        # 22 slash commands
└── skills/           # 8 agent specializations

.gemini/
└── GEMINI.md         # Rules enforcement

.gsd/
├── SPEC.md           # ← START HERE
├── ROADMAP.md        # Phases
├── STATE.md          # Session memory
├── ARCHITECTURE.md   # System design
├── STACK.md          # Tech inventory
├── DECISIONS.md      # ADRs
├── JOURNAL.md        # Session log
├── TODO.md           # Quick capture
├── templates/        # Document templates
└── examples/         # Usage examples

GSD-STYLE.md          # Style guide
```

---

## 📚 Documentation

- [GSD-STYLE.md](GSD-STYLE.md) — Complete style guide
- [Examples](.gsd/examples/) — Usage walkthroughs
- [Templates](.gsd/templates/) — Document templates

---

## 🧠 Philosophy

- **Plan before building** — Specs matter
- **Fresh context > polluted context** — State dumps prevent hallucinations
- **Proof over trust** — Evidence, not claims
- **Aggressive atomicity** — 2-3 tasks per plan

---

*Adapted from [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done) for Google Antigravity*