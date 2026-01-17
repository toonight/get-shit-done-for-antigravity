#!/bin/bash
# GSD Master Validation Script
# Runs all validators and reports overall status

total_errors=0
script_dir="$(dirname "$0")"

echo ""
echo "╔═══════════════════════════════════════════════════════╗"
echo "║         GSD ► RUNNING ALL VALIDATORS                  ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# Run workflow validator
echo "▶ Running workflow validation..."
"$script_dir/validate-workflows.sh"
if [ $? -ne 0 ]; then ((total_errors++)); fi
echo ""

# Run skill validator
echo "▶ Running skill validation..."
"$script_dir/validate-skills.sh"
if [ $? -ne 0 ]; then ((total_errors++)); fi
echo ""

# Run template validator
echo "▶ Running template validation..."
"$script_dir/validate-templates.sh"
if [ $? -ne 0 ]; then ((total_errors++)); fi
echo ""

# Summary
echo "╔═══════════════════════════════════════════════════════╗"
echo "║                    SUMMARY                            ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

if [ $total_errors -eq 0 ]; then
    echo "✅ All validators passed!"
    exit 0
else
    echo "❌ $total_errors validator(s) failed"
    exit 1
fi
