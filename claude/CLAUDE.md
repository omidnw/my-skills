# CLAUDE.md — Personal Agent Skills for Claude Code

## About this folder

This folder packages a personal collection of **Agent Skills** — the workflows, guardrails, and domain knowledge distilled from real project experience — ready to drop into any Claude Code project.

- **Skills** (load on demand): `.claude/skills/`
- **Rules** (always loaded): `.claude/rules/`

Everything is written in English.

## Universal rules

**Language — always answer in English.** Even when the user writes or asks in another language, or explicitly requests a reply in that language, answer in English. Work and information gathering always happen in English.

The remaining rules are always loaded from `.claude/rules/`:

- `safety.md` — never commit/push without explicit approval; prefer reversible operations.
- `agent-behavior.md` — inspect before editing, smallest change, verify, report honestly.
- `engineering-preferences.md` — Conventional Commits, behavior-describing names, simple over clever.
- `language.md` — the always-English rule.

## Skills index

All 9 skills in `.claude/skills/` follow the open Agent Skills standard (`SKILL.md` with YAML frontmatter, optional `references/` and `scripts/`). The two ZCode-only skills (`context-compact`, `session-handoff`) are shipped only in the `zcode/` folder. See `README.md` in this folder for the full "what it does / why it was created" table.