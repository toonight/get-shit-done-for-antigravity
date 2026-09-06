# Antigravity CLI (agy) User Guide for GSD

> Complete operational guide for executing Get Shit Done (GSD) workflows natively inside the Antigravity CLI (`agy`).

---

## 🎯 Overview

While GSD works inside the Antigravity IDE, power users frequently prefer the **Antigravity CLI (`agy`)** for:
- **Faster execution**: Terminal-native, zero GUI rendering overhead.
- **Headless automation**: Scriptable workflows with autonomous subagent loops.
- **Multi-session scaling**: Running independent phases in parallel terminal tabs or Git worktrees.
- **Direct shell integration**: Seamless interaction with system compilers, Docker, and CI tools.

---

## 🚀 Quick Setup in Any CLI Project

### 1. Initialize GSD in Your Project Directory

Open your terminal in your target repository:

```bash
# Clone the template
git clone https://github.com/toonight/get-shit-done-for-antigravity.git /tmp/gsd-template

# Copy GSD files into project root
cp -r /tmp/gsd-template/.agent ./
cp -r /tmp/gsd-template/.agents ./
cp -r /tmp/gsd-template/.gemini ./
cp -r /tmp/gsd-template/.gsd ./
cp -r /tmp/gsd-template/adapters ./
cp -r /tmp/gsd-template/docs ./
cp -r /tmp/gsd-template/scripts ./
cp -f /tmp/gsd-template/PROJECT_RULES.md ./
cp -f /tmp/gsd-template/GSD-STYLE.md ./
cp -f /tmp/gsd-template/model_capabilities.yaml ./

# Clean up
rm -rf /tmp/gsd-template
```

### 2. Verify Your GSD Setup

Run the validation suite to confirm all workflows, skills, and subagent configs are correctly placed:

```bash
./scripts/validate-all.sh
```

---

## 💻 Running GSD in Antigravity CLI

Launch an interactive Antigravity CLI session in your workspace:

```bash
agy
```

Once inside the `agy` prompt, commands are typed directly as chat messages:

```
agy > /new-project
```

> **Note on Slash Commands**: Slash commands in `agy` are workflow triggers. Type them directly (e.g. `/plan 1`, `/execute 1`, `/verify 1`) followed by Enter. You do not need IDE GUI autocomplete popups.

---

## 🔄 Core CLI Workflow Step-by-Step

### Step 1: Initialize Specification (`/new-project`)
```
agy > /new-project
```
- The agent conducts an interactive interview to extract domain requirements.
- Generates `.gsd/spec.md`, `.gsd/roadmap.md`, and `.gsd/architecture.md`.
- Review the generated files directly in your terminal:
  ```bash
  cat .gsd/spec.md
  ```

### Step 2: Plan Phase 1 (`/plan 1`)
```
agy > /plan 1
```
- Invokes the `gsd-planner` subagent in an isolated context.
- Produces atomic XML tasks in `.gsd/phases/01-foundation/PLAN.md`.

### Step 3: Execute Phase 1 (`/execute 1`)
```
agy > /execute 1
```
- Spawns `gsd-executor` subagents per wave.
- Generates code changes and performs automated atomic Git commits.
- Verifies commit status in terminal:
  ```bash
  git log --oneline -5
  ```

### Step 4: Validate Phase 1 (`/verify 1`)
```
agy > /verify 1
```
- Dispatches `gsd-verifier` with clean, unpolluted context.
- Executes automated test suites in the CLI environment and writes proof to `VERIFICATION.md`.

---

## ⚡ CLI Power Techniques

### 1. Headless / Non-Interactive Scripting
For automated pipelines or overnight runs, launch `agy` with headless non-interactive flags or wrap execution in bash:

```bash
# Launch with automated confirmation
agy -yolo "/execute 1"
```

### 2. Multi-Terminal & Git Worktree Scaling
Work on independent roadmap phases concurrently using Git worktrees and parallel `agy` sessions:

```bash
# Create an isolated worktree for Phase 2
git worktree add ../project-phase-2 -b phase-2-feature

# Open a separate terminal in that worktree
cd ../project-phase-2
agy
agy > /execute 2
```

### 3. Direct Subagent Monitoring
Antigravity CLI provides native subagent tracking. Check subagent lifecycle and execution trees directly:
- `gsd-planner`: Formulates task graphs without code pollution.
- `gsd-executor`: Implements atomic diffs per plan.
- `gsd-verifier`: Conducts unbiased verification audits.

---

## 🛠️ CLI Troubleshooting & Best Practices

| Issue in `agy` | Root Cause | Solution |
| :--- | :--- | :--- |
| **Command says "no matching workflow"** | Typing slash commands without space or wrong case | Ensure commands are lowercase with arguments separated by a space (e.g. `/plan 1`). |
| **Context window fills up too fast** | Running entire project in one long conversation | Never execute multiple phases in one thread. Run `/pause`, restart `agy`, and resume with `/execute [N]`. |
| **Commit hooks block execution** | Pre-commit linter or formatting failure | Check linter output via `git status` or inspect `.gsd/phases/XX/SUMMARY.md` for error output. |
| **Permission denied on validator scripts** | Scripts lack execute permissions | Run `chmod +x scripts/*.sh` before executing. |

---

## 📋 CLI Quick Reference Card

```bash
agy                   # Launch interactive session
/map                  # Scan codebase -> ARCHITECTURE.md
/new-project          # Requirements discovery -> SPEC.md
/plan [N]             # Phase planning -> PLAN.md
/execute [N]          # Wave implementation + Atomic commits
/verify [N]           # Empirical validation -> VERIFICATION.md
/debug [issue]        # Systematic 3-strike debugging
/progress             # View roadmap completion status
/pause                # Save state snapshot and exit session
```
