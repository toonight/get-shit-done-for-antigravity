---
description: Install GSD into the current project from GitHub
---

# /install Workflow

<objective>
Install GSD for Antigravity into the current project from GitHub.
</objective>

<process>

## 1. Check for Existing Installation

Look for GSD marker directories:

**PowerShell:**
```powershell
$alreadyInstalled = (Test-Path ".agent") -or (Test-Path ".gsd")
if ($alreadyInstalled) {
    Write-Output "GSD files detected in this project."
}
```

**Bash:**
```bash
if [ -d ".agent" ] || [ -d ".gsd" ]; then
    echo "GSD files detected in this project."
fi
```

**If already installed:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► ALREADY INSTALLED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GSD files already exist in this project.

───────────────────────────────────────────────────────

A) Reinstall — Overwrite with latest version
B) Cancel — Keep current installation

If you want to update instead: /update

───────────────────────────────────────────────────────
```

If user chooses Cancel, exit.
If user chooses Reinstall, continue to Step 2.

---

## 2. Clone from GitHub

```bash
git clone --depth 1 https://github.com/toonight/get-shit-done-for-antigravity.git .gsd-install-temp
```

---

## 3. Copy Files

**PowerShell:**
```powershell
# Core directories
Copy-Item -Recurse ".gsd-install-temp\.agent" ".\"
Copy-Item -Recurse ".gsd-install-temp\.gemini" ".\"
Copy-Item -Recurse ".gsd-install-temp\.gsd" ".\"
Copy-Item -Recurse ".gsd-install-temp\adapters" ".\"
Copy-Item -Recurse ".gsd-install-temp\docs" ".\"
Copy-Item -Recurse ".gsd-install-temp\scripts" ".\"

# Root files
Copy-Item -Force ".gsd-install-temp\PROJECT_RULES.md" ".\"
Copy-Item -Force ".gsd-install-temp\GSD-STYLE.md" ".\"
Copy-Item -Force ".gsd-install-temp\model_capabilities.yaml" ".\"
```

**Bash:**
```bash
# Core directories
cp -r .gsd-install-temp/.agent ./
cp -r .gsd-install-temp/.gemini ./
cp -r .gsd-install-temp/.gsd ./
cp -r .gsd-install-temp/adapters ./
cp -r .gsd-install-temp/docs ./
cp -r .gsd-install-temp/scripts ./

# Root files
cp .gsd-install-temp/PROJECT_RULES.md ./
cp .gsd-install-temp/GSD-STYLE.md ./
cp .gsd-install-temp/model_capabilities.yaml ./
```

---

## 4. Cleanup

**PowerShell:**
```powershell
Remove-Item -Recurse -Force ".gsd-install-temp"
```

**Bash:**
```bash
rm -rf .gsd-install-temp
```

---

## 5. Add to .gitignore (Optional)

Check if `.gsd/STATE.md` and other session files should be gitignored:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► ADD TO .gitignore?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommended .gitignore additions for session-specific files:

.gsd/STATE.md
.gsd/JOURNAL.md
.gsd/TODO.md

───────────────────────────────────────────────────────

A) Yes — Add recommended entries
B) No — Skip

───────────────────────────────────────────────────────
```

---

## 6. Confirm Installation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► INSTALLED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GSD for Antigravity has been installed.

Files installed:
• .agent/        (workflows + skills)
• .gemini/       (Gemini integration)
• .gsd/          (project state templates)
• adapters/      (model-specific enhancements)
• docs/          (operational documentation)
• scripts/       (utility scripts)
• PROJECT_RULES.md
• GSD-STYLE.md
• model_capabilities.yaml

───────────────────────────────────────────────────────

Next step:

/new-project — Initialize your project with GSD

───────────────────────────────────────────────────────
```

</process>

<notes>
- This workflow is designed to work from a clean project (no prior GSD installation)
- It copies ALL necessary files, unlike manual installation which may miss some
- For updates to an existing installation, use /update instead
- The /new-project command should be run after installation to set up SPEC.md
</notes>
