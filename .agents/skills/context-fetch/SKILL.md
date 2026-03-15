---
name: Context Fetch
description: Search-first skill to reduce unnecessary file reads by searching before loading
---

# Context Fetch Skill

<role>
You are a context-efficient agent. Your job is to find relevant code with minimal file reads.

**Core principle:** Search first, read targeted sections, never load full files blindly.
</role>

---

## When to Use

Activate this skill **before**:
- Starting any coding task
- Beginning a refactor
- Investigating a bug
- Understanding unfamiliar code

---

## Process

### Step 1: Define the Question

What are you trying to find or understand?

Examples:
- "Where is the login endpoint defined?"
- "How does the caching layer work?"
- "What calls the `processPayment` function?"

### Step 2: Identify Keywords

Extract searchable terms:

| Question | Keywords |
|----------|----------|
| Login endpoint | `login`, `auth`, `POST.*login` |
| Caching layer | `cache`, `redis`, `memoize` |
| Payment calls | `processPayment`, `payment` |

### Step 3: Search Before Reading

**PowerShell:**
```powershell
# Simple pattern search
Select-String -Path "src/**/*.ts" -Pattern "login" -Recurse

# With ripgrep (if available)
rg "login" --type ts
```

**Bash:**
```bash
# With ripgrep (recommended)
rg "login" --type ts

# With grep
grep -r "login" src/ --include="*.ts"
```

### Step 4: Evaluate Results

From search results, identify:

1. **Primary candidates** — Files directly matching your question
2. **Secondary candidates** — Files that reference primary candidates
3. **Ignore list** — Files with keyword but unrelated context

### Step 5: Targeted Reading

Only read what's justified:

```powershell
# Read specific line range (PowerShell)
Get-Content "src/auth/login.ts" | Select-Object -Skip 49 -First 30

# Read specific function (with view_code_item tool)
# view_code_item: src/auth/login.ts -> handleLogin
```

---

## Inputs

When invoking this skill, provide:

| Input | Description | Example |
|-------|-------------|---------|
| **Question** | What you're trying to find | "Where is user validation?" |
| **Scope** | Directory or file pattern | `src/`, `*.service.ts` |
| **Keywords** | Terms to search for | `validate`, `user`, `schema` |

---

## Outputs

After executing this skill, report:

1. **Candidate files** — Ranked by relevance
2. **Relevant extracts** — Key snippets found
3. **Next reads** — Specific files/line-ranges to read next
4. **Skip list** — Files searched but not relevant

---

## Anti-Patterns

### ❌ Loading Everything First

```
# BAD: Reading 5 full files to "understand context"
Read: src/auth/login.ts (500 lines)
Read: src/auth/register.ts (400 lines)
Read: src/auth/types.ts (200 lines)
```

### ✅ Search Then Target

```
# GOOD: Search first, read only what's needed
Search: "validatePassword" in src/auth/
Found: login.ts:45, register.ts:78
Read: login.ts lines 40-60
```

### ❌ Broad Searches

```
# BAD: Searching for common terms
Search: "function" → 10,000 results
```

### ✅ Specific Searches

```
# GOOD: Searching for specific identifiers
Search: "validateUserCredentials" → 3 results
```

---

## Context Efficiency Metrics

Track your efficiency:

| Metric | Good | Poor |
|--------|------|------|
| Files searched | 10+ | <5 |
| Files fully read | <3 | 10+ |
| Lines read | <200 | 1000+ |
| Targeted sections | Yes | No |

---

## Integration with GSD

This skill supports GSD's context management:

- **Prevents context pollution** — Less irrelevant code loaded
- **Supports wave execution** — Each wave starts with minimal context
- **Enables model switching** — Less context = easier handoff

---

## Quick Reference

```
1. Define question     → What am I looking for?
2. Extract keywords    → What terms to search?
3. Search codebase     → rg/grep/Select-String
4. Evaluate results    → Which files matter?
5. Read targeted       → Specific lines only
6. Report findings     → Candidates + extracts
```

---

*Part of GSD methodology. See PROJECT_RULES.md for search-first discipline rules.*
