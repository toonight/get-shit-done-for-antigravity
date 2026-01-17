# Changelog

All notable changes to GSD for Antigravity.

## [1.4.0] - 2026-01-17

### Added
- **Template Parity** — 8 new templates (22 total)
  - `architecture.md`, `decisions.md`, `journal.md`, `stack.md`
  - `phase-summary.md`, `sprint.md`, `todo.md`, `spec.md`
- `validate-templates.ps1/.sh` — template validation scripts
- `validate-all` now includes template validation

---

## [1.3.0] - 2026-01-17

### Added
- **Validation Scripts** — expanded testing infrastructure
  - `validate-skills.ps1/.sh` — verify skill directory structure
  - `validate-all.ps1/.sh` — master script runs all validators
- **VERSION file** — single source of truth for version
- `/help` now displays current version

### Changed
- README.md updated with Testing section

---

## [1.2.0] - 2026-01-17

### Added
- **Cross-Platform Support** — All 16 workflow files now have Bash equivalents
- `/web-search` — Search the web for technical research

### Changed
- README.md updated with dual-syntax Getting Started (PowerShell + Bash)
- README.md added Cross-Platform Support section
- Git commands in workflows use `bash` syntax (cross-platform)

---

## [1.1.0] - 2026-01-17

### Added
- **Template Parity** — 14 templates aligned with original repository
  - `DEBUG.md`, `UAT.md`, `discovery.md`, `requirements.md`, etc.
- **Examples** — `.gsd/examples/` directory
  - `workflow-example.md` — Full workflow walkthrough
  - `quick-reference.md` — Command cheat sheet
  - `cross-platform.md` — Platform-specific guidance
- `/add-todo` — Quick capture workflow
- `/check-todos` — List pending items workflow
- `/whats-new` — Show recent changes

### Changed
- Workflows now have "Related" sections for discoverability
- Cross-linked workflows and skills

---

## [1.0.0] - 2026-01-17

### Added

**Core Workflows (21)**
- `/map` — Analyze codebase, generate ARCHITECTURE.md
- `/plan` — Create PLAN.md with XML task structure
- `/execute` — Wave-based execution with atomic commits
- `/verify` — Must-haves validation with empirical proof
- `/debug` — Systematic debugging with 3-strike rule
- `/new-project` — Deep questioning initialization (10 phases)
- `/new-milestone` — Create milestone with phases
- `/complete-milestone` — Archive and tag milestone
- `/audit-milestone` — Quality review
- `/add-phase` — Add phase to roadmap
- `/insert-phase` — Insert with renumbering
- `/remove-phase` — Remove with safety checks
- `/discuss-phase` — Clarify scope before planning
- `/research-phase` — Technical deep dive
- `/list-phase-assumptions` — Surface assumptions
- `/plan-milestone-gaps` — Gap closure plans
- `/progress` — Show current position
- `/pause` — State preservation
- `/resume` — Context restoration
- `/add-todo` — Quick capture
- `/check-todos` — List todos
- `/help` — Command reference

**Skills (8)**
- `planner` — Task anatomy, goal-backward methodology
- `executor` — Atomic commits, Need-to-Know context
- `verifier` — Must-haves extraction, evidence requirements
- `debugger` — 3-strike rule, systematic diagnosis
- `codebase-mapper` — Structure analysis, debt discovery
- `plan-checker` — Plan validation before execution
- `context-health-monitor` — Prevents context rot
- `empirical-validation` — Requires proof for changes

**Documentation**
- README.md with full methodology explanation
- GSD-STYLE.md comprehensive style guide
- Templates: PLAN.md, VERIFICATION.md, RESEARCH.md, SUMMARY.md
- Examples: workflow-example.md, quick-reference.md, cross-platform.md

**Rules**
- GEMINI.md with 4 core rules enforcement
- Planning Lock, State Persistence, Context Hygiene, Empirical Validation

### Attribution
Adapted from [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done) for Google Antigravity.
