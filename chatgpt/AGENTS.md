# AGENTS.md — ChatGPT / Codex

This folder targets **Codex**, the coding agent that powers ChatGPT Work, ChatGPT desktop, and the Codex CLI. Codex reads `AGENTS.md` files for rules and scans `.agents/skills/` for skills (project root down to the working directory), so no `.chatgpt` folder is needed — rules live here in `AGENTS.md` and skills in `.agents/skills/`. For global use, copy the skills to `~/.agents/skills/` and this file to `~/.codex/AGENTS.md`.

## Language (Always English)

Always answer in English — even when the user writes or asks in another language, or explicitly requests a reply in that language. Work and information gathering always happen in English.

## Safety Rules

### Git safety
Never commit, push, or create a PR without explicit user approval.

- **Explicit** means the user literally says "commit this", "push it", or "submit a PR".
- **Not explicit:** "go ahead", "do it", "apply it", "fix it", "sounds good", "yes".
- Showing diffs, staging, and suggesting commit messages are always OK. When uncertain, ask.

### Irreversible operations
Before any operation that can cause irreversible loss of data, state, configuration, or system behavior (migration, schema change, data manipulation, `rm`/`drop`/`delete`, config edits), ensure a backup exists or the change is reversible. Prefer additive, reversible changes.

## Agent Behavior

- **Inspect before editing** — never modify a file you have not read.
- **Do not assume requirements** — when ambiguity affects architecture or behavior, ask before coding.
- **Smallest change** that satisfies the requirement; preserve existing behavior; avoid unrelated refactoring.
- **Match existing patterns** over inventing new ones; prefer fewer dependencies.
- **Verify before uncertain changes** — check official documentation or source instead of guessing.
- **Report honestly** — never present unverified work as done; say plainly when something is partial or failed.

## Engineering Preferences

- **Commits:** short, meaningful Conventional Commits — `<type>: <short description>` with `feat`, `fix`, `revert`, `chore`, `docs`. Keep commits small, focused, and atomic.
- **Naming:** names describe actual behavior — avoid `handle()`, `process()`, `doSomething()`; prefer `fetchUserProfile()`, `validatePaymentToken()`.
- **Explicit over implicit:** make contracts visible, name things clearly, define data shapes, avoid hidden behavior.
- **Simple over clever:** simple solutions over flexible ones; maintainability over cleverness; fewer dependencies.
- **No speculative features** (YAGNI) — build only what is needed now.
- **File size:** keep files under ~1000 lines; split into focused modules when approaching the limit.

## Available Skills

Skills live in `.agents/skills/` (9 portable skills, standard `SKILL.md` format; the ZCode-only `context-compact` and `session-handoff` ship only in `zcode/`). See `README.md` for the "what it does / why it was created" table.