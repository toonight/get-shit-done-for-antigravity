---
name: subagent-delegation
description: Canonical protocol for delegating GSD work to native Antigravity subagents — when to delegate, how to invoke, workspace isolation modes, and the inline fallback for older IDE versions
---

# Subagent Delegation Protocol

<role>
You are an orchestrator. Your context is a budget, and the work you do yourself spends it.

Delegation is not an optimization in GSD — it is the mechanism that makes the quality
thresholds in PROJECT_RULES.md achievable. An orchestrator that reads twenty files to plan a
phase has already spent the context the phase needed.
</role>

---

## Requirements

Native subagents require **Antigravity 2.0 or later** (`invoke_subagent`).

Detect capability by checking whether `invoke_subagent` is in your available tools. Do not
probe by calling it — a failed call wastes a turn and confuses the user.

| Capability | Behavior |
|------------|----------|
| `invoke_subagent` available | Delegate per this protocol |
| Not available | Inline fallback (see below) |

**Plan requirements:** none beyond 2.0. Plain subagents are not plan-gated — only
*Multi-Agent Teamwork* (`/teamwork-preview`, Agent Teams) is Ultra-exclusive, and GSD never
uses it. If delegation is unavailable, the cause is the IDE version, not the subscription.

---

## What to Delegate

| Work | Subagent | Why |
|------|----------|-----|
| Executing a PLAN.md | `gsd-executor` | One clean context per plan is the core GSD promise |
| Authoring plans for a phase | `gsd-planner` | Plan authoring reads spec + roadmap + research |
| Verifying a phase | `gsd-verifier` | Independence requires a context that never saw the work |
| Codebase mapping / research | `gsd-researcher` | Exploration is the largest single context cost |
| Diagnosing a bug | `gsd-debugger` | A polluted context repeats its own failed hypotheses |

**Keep in the orchestrator:** argument parsing, file existence checks, wave grouping, reading
compact subagent results, updating STATE.md and ROADMAP.md, and talking to the user.

Everything else is delegable. When in doubt, delegate — the cost of an extra subagent is
tokens; the cost of a poisoned orchestrator context is the rest of the session.

---

## Invocation

Call `invoke_subagent`, targeting the subagent by the `name` in its `.agents/agents/*.md`
definition. The tool's exact parameter schema is supplied by the IDE — follow it. This
protocol governs **what you put in the prompt**, not the wire format.

A subagent **does not inherit your conversation history**. It starts from a clean slate.
Anything you do not put in its prompt does not exist for it.

Every invocation prompt must carry:

1. **The contract fields** the target subagent declares in its Invocation Contract table
2. **Paths, not contents** — `.gsd/phases/2/1-PLAN.md`, never the pasted plan
3. **Constraints from STATE.md** that bound the work — decisions already made, known blockers
4. **The return contract** — restate that you want the compact block, nothing more

Never paste file contents into a subagent prompt. It can read. Pasting doubles the token
cost and desynchronizes it from disk the moment anything changes.

---

## Tool Grants

**`tools:` defaults to an empty list — it does not inherit the parent's toolset.** A subagent
whose definition omits `tools:` cannot write files. It will explore happily, then discover at
the end that it has no way to produce its artifact.

Every subagent definition in `.agents/agents/` therefore declares its tools explicitly.

| Need | Tools |
|------|-------|
| Read and search | `view_file`, `list_dir`, `find_by_name`, `grep_search` |
| Write artifacts | `write_to_file`, `replace_file_content`, `multi_replace_file_content` |
| Commits, tests, verification commands | `run_command` |
| External research | `search_web`, `read_url_content` |
| Return to the parent | `send_message` |

**Copy tool names exactly.** An unmapped or misspelled name makes the subagent hang rather
than fail — the worst possible failure mode, because it looks like slow work.

`scripts/validate-agents.ps1/.sh` enforces both rules: `tools:` must be present and non-empty,
and every declared name must exist in the registry above.

---

## Workspace Isolation

| Mode | Use when |
|------|----------|
| `inherit` | Sequential work — one subagent touching the workspace at a time |
| `branch` | Two or more subagents writing files concurrently (isolated git worktree) |
| `share` | Read-only concurrent work — research, mapping, verification |

**Wave mapping:** a wave with one plan runs `inherit`. A wave with multiple plans runs
`branch`, one worktree per plan, merged after the wave completes. Concurrent writers sharing
a workspace corrupt each other's commits — this is not a theoretical risk.

---

## Handling Results

A subagent returns its compact block. That block is what enters your context — nothing else.

- **Do not re-read the artifact** the subagent wrote to confirm it. If you need its contents
  later, read it then.
- **Do not summarize the summary** back to the user in full. Report status, path, and the
  one thing they must decide.
- **Route on status.** `blocked`, `checkpoint`, `needs_input`, `escalate`, and `fail` each
  have a defined next step in the calling workflow. Follow it.
- **A dead subagent is not a completed one.** If a subagent returns nothing or dies, report
  it as a failure and stop. Do not silently redo its work inline — that is precisely the
  context blow-up delegation exists to prevent.
- **A subagent that returns file contents has failed, however complete it sounds.** The
  contract is a path; a payload means the artifact never reached disk. Treat it as `blocked`,
  find out which capability it lacked, and fix the definition — do not paste the content
  onward, or the delegation cost you tokens and bought you nothing.

Depth is capped at 10 levels of nesting. GSD never needs more than 2 — orchestrator to
subagent. A subagent that wants to delegate should return `needs_input` instead.

---

## Inline Fallback

On Antigravity 1.x, `invoke_subagent` does not exist. Workflows still run, in **degraded
mode**: the orchestrator does the work itself, in its own context.

When falling back, tell the user once, at the start:

```
⚠️  Subagent delegation unavailable (requires Antigravity 2.0+)
    Running inline — context will fill faster.
    Recommended: one plan per session, /pause between plans.
```

Then apply the degraded-mode discipline:

- Execute **one** plan per invocation, never a full wave
- `/pause` after each plan and let the user `/resume` in a fresh session
- Watch `skills/context-health-monitor` thresholds and stop at 70%

Do not silently pretend to delegate. The failure this protocol was written to fix was
workflows describing subagents they never spawned.
