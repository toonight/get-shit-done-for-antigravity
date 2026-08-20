#!/bin/bash
# GSD Subagent Validation Script
# Validates all subagent definitions in .agents/agents/

error_count=0
agents_checked=0

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " GSD ► VALIDATING SUBAGENTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -d ".agents/agents" ]; then
    echo "❌ Missing .agents/agents/ directory"
    exit 1
fi

for agent_file in .agents/agents/*.md; do
    [ -e "$agent_file" ] || continue
    ((agents_checked++))
    agent_name=$(basename "$agent_file" .md)
    has_errors=false

    # Check for frontmatter
    if ! head -1 "$agent_file" | grep -q "^---"; then
        echo "❌ $agent_name: Missing frontmatter"
        ((error_count++))
        has_errors=true
    fi

    # Check required fields
    for field in "name" "description" "subagent"; do
        if ! grep -q "^$field:" "$agent_file"; then
            echo "❌ $agent_name: Missing $field in frontmatter"
            ((error_count++))
            has_errors=true
        fi
    done

    # name must match filename (invoke_subagent targets the name field)
    declared_name=$(grep "^name:" "$agent_file" | head -1 | sed 's/^name:[[:space:]]*//')
    if [ -n "$declared_name" ] && [ "$declared_name" != "$agent_name" ]; then
        echo "❌ $agent_name: name '$declared_name' does not match filename"
        ((error_count++))
        has_errors=true
    fi

    # subagent must be true
    if ! grep -q "^subagent:[[:space:]]*true" "$agent_file"; then
        echo "❌ $agent_name: subagent must be true"
        ((error_count++))
        has_errors=true
    fi

    # Referenced skills must exist
    while read -r skill_ref; do
        [ -n "$skill_ref" ] || continue
        if [ ! -f ".agents/$skill_ref/SKILL.md" ]; then
            echo "❌ $agent_name: References missing skill '$skill_ref'"
            ((error_count++))
            has_errors=true
        fi
    done < <(grep -oE "^[[:space:]]+- skills/[a-z0-9-]+" "$agent_file" | sed 's/^[[:space:]]*-[[:space:]]*//')

    # Return Contract keeps orchestrator context lean
    if ! grep -q "Return Contract" "$agent_file"; then
        echo "⚠️  $agent_name: Missing Return Contract section"
    fi

    if [ "$has_errors" = false ]; then
        echo "✅ $agent_name"
    fi
done

echo ""
echo "───────────────────────────────────────────────────────"
echo ""
echo "Subagents checked: $agents_checked"
echo "Errors: $error_count"
echo ""

if [ $error_count -eq 0 ]; then
    echo "✅ All subagents valid!"
    exit 0
else
    echo "❌ Validation failed"
    exit 1
fi
