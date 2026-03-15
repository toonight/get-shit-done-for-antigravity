---
description: Search the web for information to inform decisions
argument-hint: "<query> [--domain <site>]"
---

# /web-search Workflow

<objective>
Search the web to gather information for technical decisions, API documentation, library comparisons, or any research need.
</objective>

<when_to_use>
- Evaluating libraries or frameworks
- Finding API documentation
- Checking current best practices
- Researching error messages
- Comparing implementation approaches
- Getting up-to-date information on tools/services
</when_to_use>

<process>

## 1. Formulate Query

Parse the user's request into a focused search query.

**Good queries:**
- Specific: "Next.js 14 app router authentication best practices"
- Targeted: "Prisma vs Drizzle ORM comparison 2024"
- Actionable: "how to fix CORS error Express.js"

**Bad queries:**
- Too broad: "how to code"
- Too vague: "best database"

---

## 2. Execute Search

Use the `search_web` tool with:
- Query: The formulated search query
- Domain (optional): Prioritize specific site (e.g., `docs.python.org`)

---

## 3. Analyze Results

From the search results:
1. **Extract key information** relevant to the user's need
2. **Note sources** for citations
3. **Identify patterns** across multiple results
4. **Flag contradictions** or outdated information

---

## 4. Summarize Findings

Present findings clearly:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSD ► WEB SEARCH RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Query: {query}

───────────────────────────────────────────────────────

KEY FINDINGS
────────────
• {finding 1}
• {finding 2}
• {finding 3}

RECOMMENDATION
──────────────
{actionable recommendation based on findings}

SOURCES
───────
• {source 1}
• {source 2}

───────────────────────────────────────────────────────
```

---

## 5. Offer Next Steps

Based on findings:
- Suggest follow-up searches if needed
- Recommend adding to RESEARCH.md for project context
- Offer to implement based on findings

</process>

<integration>
## Integration with GSD

**During /research-phase:**
Use `/web-search` to gather information for RESEARCH.md.

**During /plan:**
Use `/web-search` when discovery level 1-3 indicates research needed.

**During /debug:**
Use `/web-search` to find solutions to error messages.
</integration>

<related>
## Related

### Workflows
| Command | Relationship |
|---------|--------------|
| `/research-phase` | Uses web-search for phase research |
| `/plan` | May trigger web-search for discovery |
| `/debug` | Search for error solutions |

</related>
