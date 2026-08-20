#!/bin/bash
# GSD Script Encoding Validation
# Checks that every PowerShell script with non-ASCII characters carries a UTF-8 BOM.
#
# Windows PowerShell 5.1 reads .ps1 files as the system ANSI codepage unless a
# UTF-8 BOM is present. A script with non-ASCII characters and no BOM fails to
# parse entirely — the failure looks like a syntax error, not an encoding one.
#
# The PowerShell counterpart (validate-encoding.ps1) additionally parses each
# script. Run it on Windows for the stronger check.

error_count=0
scripts_checked=0

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " GSD ► VALIDATING SCRIPT ENCODING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

script_dir="$(dirname "$0")"

for file in "$script_dir"/*.ps1; do
    [ -e "$file" ] || continue
    ((scripts_checked++))
    filename=$(basename "$file")

    # Count bytes outside the ASCII range
    non_ascii=$(LC_ALL=C tr -d '\000-\177' < "$file" | wc -c)

    # Detect a UTF-8 BOM (EF BB BF)
    bom=$(LC_ALL=C head -c 3 "$file" | od -An -tx1 | tr -d ' \n')

    if [ "$non_ascii" -gt 0 ] && [ "$bom" != "efbbbf" ]; then
        echo "❌ $filename: non-ASCII characters without a UTF-8 BOM"
        ((error_count++))
    else
        echo "✅ $filename"
    fi
done

echo ""
echo "───────────────────────────────────────────────────────"
echo ""
echo "Scripts checked: $scripts_checked"
echo "Errors: $error_count"
echo ""

if [ $error_count -eq 0 ]; then
    echo "✅ All scripts correctly encoded!"
    exit 0
else
    echo "❌ Validation failed"
    echo ""
    echo "Fix: prepend a UTF-8 BOM to the reported file(s)."
    exit 1
fi
