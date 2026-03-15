---
name: Empirical Validation
description: Requires proof before marking work complete — no "trust me, it works"
---

# Empirical Validation

## Core Principle

> **"The code looks correct" is NOT validation.**
> 
> Every change must be verified with empirical evidence before being marked complete.

## Validation Methods by Change Type

| Change Type | Required Validation | Tool |
|-------------|---------------------|------|
| **UI Changes** | Screenshot showing expected visual state | `browser_subagent` |
| **API Endpoints** | Command showing correct response | `run_command` |
| **Build/Config** | Successful build or test output | `run_command` |
| **Data Changes** | Query showing expected data state | `run_command` |
| **File Operations** | File listing or content verification | `run_command` |

## Validation Protocol

### Before Marking Any Task "Done"

1. **Identify Verification Criteria**
   - What should be true after this change?
   - How can that be observed?

2. **Execute Verification**
   - Run the appropriate command or action
   - Capture the output/evidence

3. **Document Evidence**
   - Add to `.gsd/JOURNAL.md` under the task
   - Include actual output, not just "passed"

4. **Confirm Against Criteria**
   - Does evidence match expected outcome?
   - If not, task is NOT complete

## Examples

### API Endpoint Verification
```powershell
# Good: Actual test showing response
curl -X POST http://localhost:3000/api/login -d '{"email":"test@test.com"}' 
# Output: {"success":true,"token":"..."}

# Bad: Just saying "endpoint works"
```

### UI Verification
```
# Good: Take screenshot with browser tool
- Navigate to /dashboard
- Capture screenshot
- Confirm: Header visible? Data loaded? Layout correct?

# Bad: "The component should render correctly"
```

### Build Verification
```powershell
# Good: Show build output
npm run build
# Output: Successfully compiled...

# Bad: "Build should work now"
```

## Forbidden Phrases

Never use these as justification for completion:
- "This should work"
- "The code looks correct"
- "I've made similar changes before"
- "Based on my understanding"
- "It follows the pattern"

## Integration

This skill integrates with:
- `/verify` — Primary workflow using this skill
- `/execute` — Must validate before marking tasks complete
- Rule 4 in `GEMINI.md` — Empirical Validation enforcement

## Failure Handling

If verification fails:

1. **Do NOT mark task complete**
2. **Document** the failure in `.gsd/STATE.md`
3. **Create** fix task if cause is known
4. **Trigger** Context Health Monitor if 3+ failures
