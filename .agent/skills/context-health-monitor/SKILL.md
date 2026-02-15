---
name: Context Health Monitor
description: Monitors context complexity and triggers state dumps before quality degrades
---

# Context Health Monitor

## Purpose

Prevent "Context Rot" — the quality degradation that occurs as the agent processes more information in a single session.

## When This Skill Activates

The agent should self-monitor for these warning signs:

### Warning Signs

| Signal | Threshold | Action |
|--------|-----------|--------|
| Repeated debugging | 3+ failed attempts | Trigger state dump |
| Going in circles | Same approach tried twice | Stop and reassess |
| Confusion indicators | "I'm not sure", backtracking | Document uncertainty |
| Session length | Extended back-and-forth | Recommend `/pause` |

## Behavior Rules

### Rule 1: The 3-Strike Rule

If debugging the same issue fails 3 times:

1. **STOP** attempting fixes
2. **Document** in `.gsd/STATE.md`:
   - What was tried
   - What errors occurred
   - Current hypothesis
3. **Recommend** user start fresh session
4. **Do NOT** continue with more attempts

### Rule 2: Circular Detection

If the same approach is being tried again:

1. **Acknowledge** the repetition
2. **List** what has already been tried
3. **Propose** a fundamentally different approach
4. **Or** recommend `/pause` for fresh perspective

### Rule 3: Uncertainty Logging

When uncertain about an approach:

1. **State** the uncertainty clearly
2. **Document** in `.gsd/DECISIONS.md`:
   - The uncertain decision
   - Why it's uncertain
   - Alternatives considered
3. **Ask** user for guidance rather than guessing

## State Dump Format

When triggered, write to `.gsd/STATE.md`:

```markdown
## Context Health: State Dump

**Triggered**: [date/time]
**Reason**: [3 failures / circular / uncertainty]

### What Was Attempted
1. [Approach 1] — Result: [outcome]
2. [Approach 2] — Result: [outcome]
3. [Approach 3] — Result: [outcome]

### Current Hypothesis
[Best guess at root cause]

### Recommended Next Steps
1. [Fresh perspective action]
2. [Alternative approach to try]

### Files Involved
- [file1.ext] — [what state it's in]
- [file2.ext] — [what state it's in]
```

## Auto-Save Protocol

**Critical:** When any warning signal triggers, the agent must save state BEFORE recommending `/pause` to the user. This ensures state persists even if the session hard-terminates.

### Steps

1. **Write** a state snapshot to `.gsd/STATE.md` immediately when a threshold is hit
2. **Include** at minimum: current phase, current task, last action, next step
3. **Then** inform the user of the situation and recommend `/pause`

### Why

Sessions can terminate abruptly (usage limits, context limits, network errors). If the agent waits for the user to type `/pause`, it may never get the chance. By saving first and recommending second, state is always preserved.

## Integration

This skill integrates with:
- `/pause` — Triggers proper session handoff (includes proactive auto-save)
- `/resume` — Loads the state dump context
- Rule 3 in `GEMINI.md` — Context Hygiene enforcement
