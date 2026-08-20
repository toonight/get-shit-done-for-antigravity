# Changelog

All notable changes to GSD for Antigravity.

## [1.6.0] - 2026-08-20

### Added
- **Native subagent delegation** — GSD workflows now delegate to Antigravity subagents via `invoke_subagent` instead of running everything in the main context window (closes #15)
- **5 subagent definitions** in `.agents/agents/` — `gsd-planner`, `gsd-executor`, `gsd-verifier`, `gsd-researcher`, `gsd-debugger`, each equipped with existing skills through the `skills:` frontmatter field
- **`subagent-delegation` skill** — canonical protocol covering what to delegate, invocation prompt contract, workspace isolation modes, result handling, and the inline fallback
- **Workspace isolation for waves** — plans sharing a wave run in isolated git worktrees (`branch` mode), merged when the wave closes
- **Delegation rule** in PROJECT_RULES.md
- `validate-agents.ps1/.sh` — validates subagent definitions, including that referenced skills actually exist; wired into `validate-all`
- **Explicit `tools:` grants** on every subagent — the field defaults to an empty list and does not inherit the parent's toolset, so subagents without it can read and explore but cannot write their own artifact
- `validate-agents` rejects a subagent with no `tools:` and any tool name outside the documented registry — a misspelled name makes a subagent hang rather than fail
- Return Contracts now require `status: blocked` when a capability is missing, and forbid sending file contents to the parent as a substitute for writing to disk
- `validate-encoding.ps1/.sh` — parses every PowerShell script and checks that any script with non-ASCII characters carries a UTF-8 BOM; wired into `validate-all`

### Changed
- `/execute` delegates one `gsd-executor` per plan and routes on compact result blocks instead of executing inline
- `/plan` delegates research to `gsd-researcher` and plan authoring to `gsd-planner`
- `/verify` delegates to `gsd-verifier` — verification now runs on a context that never saw the implementation, which changes the result and not just the token count
- `/map` and `/research-phase` delegate discovery to `gsd-researcher`
- `/debug` delegates to `gsd-debugger`, especially when the calling context has already failed to fix the issue
- README documents subagent delegation and the Antigravity 2.0+ requirement

### Fixed
- **Documentation described subagents that were never spawned** — `/execute` claimed to "spawn focused execution for each plan" with "fresh context per plan execution", `/plan` explained "why subagents", and the executor skill opened with "you are spawned by /execute". None of it was wired to anything; every phase ran in one context window until it was exhausted (#15)
- **PowerShell validators could not run on Windows** — `.ps1` scripts containing emoji were stored as UTF-8 without a BOM, so Windows PowerShell 5.1 read them as the system ANSI codepage and failed to parse them entirely (`Le terminateur " est manquant dans la chaine`). `validate-skills`, `validate-templates` and `validate-workflows` were affected
- **`validate-all.ps1` reported success when a child validator never ran** — a script that fails to launch leaves `$LASTEXITCODE` untouched, so the suite printed "All validators passed!" while nothing had been validated. This is why the encoding fault went unnoticed

### Notes
- `.gsd/ARCHITECTURE.md` and `.gsd/DECISIONS.md` are gitignored project state, not shipped template files. The design rationale for delegation lives in `.agents/skills/subagent-delegation/SKILL.md`

### Compatibility
- Requires Antigravity **2.0+** for delegation. On 1.x, workflows announce degraded mode and run inline — one plan per session, `/pause` between plans

---

## [1.5.0] - 2026-04-01

### Breaking Changes
- **Skills moved from `.agent/skills/` to `.agents/skills/`** — aligns with the [Agent Skills open standard](https://agentskills.io/specification), the universal cross-agent discovery path used by Gemini CLI, Claude Code, Cursor, VS Code Copilot, and other compatible agents
- **SKILL.md `name` fields updated** — all 11 skills now use lowercase-hyphenated names matching their folder names per spec (e.g., `GSD Executor` → `executor`)

### Added
- `/sprint` workflow — time-boxed sprints (new/status/close) for quick focused work outside the milestone cycle
- **Test Quality Rules** in `/plan` — prevents agents from gaming test suites with mock-everything, tautological assertions, or always-pass tests
- **Discovery template reference** (Level 1.5) in `/plan` — bridges the gap between quick verification and full research
- **Journal/decisions archival** in `/complete-milestone` — archives DECISIONS.md and JOURNAL.md into milestone folder, resets for next milestone
- **Architecture auto-refresh** in `/complete-milestone` — refreshes ARCHITECTURE.md and STACK.md after milestone completion
- **Requirements tracking** — `/plan` loads REQUIREMENTS.md, `/execute` updates requirement status, `/complete-milestone` archives and marks requirements
- **Session file reset** in `/new-milestone` — resets DECISIONS.md and JOURNAL.md if they've grown beyond a header
- SVG banner in README

### Changed
- README updated with `/sprint` commands section, new file structure, command count (29 total)
- All references across docs, scripts, and workflows updated for `.agents/skills/` path
- `validate-skills.ps1/.sh` updated to scan `.agents/skills/`
- `install.md` and `update.md` workflows handle both `.agent/` (workflows) and `.agents/` (skills)

### Fixed
- Skills not appearing in Antigravity after updates (closes #10)

---

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
