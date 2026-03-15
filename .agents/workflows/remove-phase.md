---
description: Remove a phase from the roadmap (with safety checks)
argument-hint: "<phase-number>"
---

# /remove-phase Workflow

<objective>
Remove a phase from the roadmap, with safety checks for in-progress or completed work.
</objective>

<process>

## 1. Validate Phase Exists

**PowerShell:**
```powershell
$phase = Select-String -Path ".gsd/ROADMAP.md" -Pattern "### Phase $N:"
if (-not $phase) {
    Write-Error "Phase $N not found in ROADMAP.md"
}
```

**Bash:**
```bash
if ! grep -q "### Phase $N:" ".gsd/ROADMAP.md"; then
    echo "Error: Phase $N not found in ROADMAP.md" >&2
fi
```

---

## 2. Check Phase Status

**PowerShell:**
```powershell
$status = Select-String -Path ".gsd/ROADMAP.md" -Pattern "Phase $N:.*\n.*Status: (.*)"
```

**Bash:**
```bash
status=$(grep -A1 "Phase $N:" ".gsd/ROADMAP.md" | grep "Status:" | cut -d: -f2)
```

**Safety checks:**

| Status | Action |
|--------|--------|
| ⬜ Not Started | Safe to remove |
| 🔄 In Progress | Warn and confirm |
| ✅ Complete | Error — archive instead |

---

## 3. Check for Dependencies

Are other phases depending on this one?

**PowerShell:**
```powershell
Select-String -Path ".gsd/ROADMAP.md" -Pattern "Depends on.*Phase $N"
```

**Bash:**
```bash
grep "Depends on.*Phase $N" ".gsd/ROADMAP.md"
```

**If dependencies exist:**
```
⚠️ Phase {M} depends on Phase {N}

Cannot remove. Consider:
1. Update dependent phases first
2. Use /insert-phase to restructure
```

---

## 4. Confirm Removal

```
⚠️ CONFIRM REMOVAL

Phase {N}: {name}
Status: {status}

This will:
- Remove phase from ROADMAP.md
- Delete .gsd/phases/{N}/ if exists
- Renumber subsequent phases

Type "REMOVE" to confirm:
```

---

## 5. Remove Phase

1. Delete from ROADMAP.md
2. Remove `.gsd/phases/{N}/` directory
3. Renumber subsequent phases (N+1 becomes N, etc.)
4. Update dependencies

---

## 6. Update STATE.md

If currently in removed phase, set to previous phase or "Planning".

---

## 7. Commit

```bash
git add -A
git commit -m "docs: remove phase {N} - {name}"
```

---

## 8. Display Result

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► PHASE REMOVED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Removed: Phase {N}: {name}
Renumbered: {M} phases

───────────────────────────────────────────────────────

/progress — See updated roadmap

───────────────────────────────────────────────────────
```

</process>
