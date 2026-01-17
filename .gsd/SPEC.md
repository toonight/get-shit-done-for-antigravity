# SPEC.md — Project Specification

> **Status**: `FINALIZED`
>
> ⚠️ **Planning Lock**: No code may be written until this spec is marked `FINALIZED`.

## Vision
A complete, self-documenting GSD methodology implementation for Google Antigravity that developers can clone and immediately start using for spec-driven, context-engineered development.

## Goals
1. **Complete Documentation** — All workflows, skills, and templates are fully documented with examples
2. **Self-Improving** — The project uses its own methodology (dogfooding validated)
3. **Production-Ready** — Can be used on real projects immediately after cloning
4. **Comparable to Original** — Feature parity with glittercowboy/get-shit-done

## Non-Goals (Out of Scope)
- npm package publishing (we're Antigravity-native, not CLI)
- Multi-user/team features (solo developer + AI focus)
- Integration with other AI coding tools

## Constraints
- Must work with Antigravity's workflow/skill system
- PowerShell commands for Windows compatibility
- Markdown-based (no custom parsers)

## Success Criteria
- [x] All 4 core rules enforced via GEMINI.md
- [x] 21 workflows covering full development lifecycle
- [x] 8 skills for specialized agent behaviors
- [x] 22 templates for consistent documentation
- [x] Running /map produces useful ARCHITECTURE.md
- [x] Running /plan creates executable PLAN.md files
- [x] Complete example demonstrating full workflow (`.gsd/examples/`)

---

*Last updated: 2026-01-17*
