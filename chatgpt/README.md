# ChatGPT (Codex) — Skills & Instructions

This folder targets **Codex** — the coding agent that powers ChatGPT Work, the ChatGPT desktop app, and the Codex CLI. There is no separate ".chatgpt" config folder: Codex reads project rules from `AGENTS.md` files and discovers skills from `.agents/skills/` (scanning every directory from the repo root down to your working directory). The same `.agents/skills` and `AGENTS.md` conventions are shared by several other tools, which is why this canonical location is used.

## Install

**Per project** — copy into your repo root:

```bash
cp -R chatgpt/.agents .           # skills
cp chatgpt/AGENTS.md .            # rules + instructions
```

**Global** — copy into your home directory:

```bash
cp -R chatgpt/.agents/skills ~/.agents/skills/
cp chatgpt/AGENTS.md ~/.codex/AGENTS.md
```

In ChatGPT, invoke a skill manually with `@`; in Codex CLI/IDE, use `/skills` or `$`. Skills also activate automatically when a request matches their description. Disable any skill via `[[skills.config]]` in `~/.codex/config.toml`.

## Layout

```
.agents/
└── skills/      9 Agent Skills (SKILL.md + references/ + scripts/) — loaded on demand
AGENTS.md        rules + instructions (Language, Safety, Agent Behavior, Engineering)
```

## Skills

| Skill | What it does | Why it was created |
|---|---|---|
| **code-quality** | Runs the project's installed formatters/linters/type-checkers against the files you changed, fixes, and re-runs — a static quality gate before declaring "done". | Stop claiming "done" while lint/type errors remain on touched files; stop scope-creep and config-silencing of violations. |
| **design-principles** | Full UI/UX playbook: design tokens, typography, spacing, motion, RTL mirroring, accessibility, dark theme — for calm, production-ready interfaces. | Recurring UI failures: `direction: rtl` without mirroring the layout, pure `#000`/`#FFF` dark themes, random colors, animation everywhere instead of on state changes. |
| **external-ai-consult** | Before heavy work, gets 2–5 de-risking questions answered by an external AI via a copy-paste block the user runs in their own AI tool. | Front-load knowledge instead of learning by costly trial-and-error; avoids vague "I need more info" dead-ends. |
| **parallel-subagents** | Splits large tasks into independent sub-agent tasks running in parallel without collision or duplication (artifact partitioning, exclusive write ownership, contract-first). | Parallel work disasters: two agents "fixing" the same bug differently, duplicate explorations, last-writer-wins silently losing work. |
| **reliable-execution** | Executes tasks the way the user expects: restate, decompose, stay in scope, gate irreversible steps, verify, report honestly. | Models that drift mid-task: coding before restating the task, "also fixing" unrelated issues, reporting success without verification. |
| **research-and-reuse** | Researches unfamiliar domain logic (sensors, DSP, crypto, ML…) from docs before implementing, and prefers maintained packages over hand-rolled code. | Domain-expert logic is full of subtle failure modes; a maintained package is exercised by thousands of users, a fresh implementation only by your tests. |
| **sudo-handoff** | Hands privileged (root/admin) commands to the user in one copy-pasteable block instead of failing on sudo. | `sudo: a password is required` was treated as a dead-end; it's really a handoff signal — the user is the privileged shell, the agent the analyst. |
| **task-intake** | Turns a raw request into a structured brief (goal, context, constraints, acceptance criteria, verification) before anything executes. | Raw requests lack the context that tells the model which knowledge to load; vague asks get executed on hope; skipping acceptance criteria is where guessing starts. |
| **tauri-v2-docs** | Resolves exact Tauri v2 documentation pages (official `llms.txt` index) for APIs, config, permissions, and plugins. | Tauri v1 docs are a recurring trap — v1 examples silently break in v2 projects; a doc map prevents mixing v1 code into v2. |

## Rules (inside AGENTS.md)

- **Language** — always answer in English, even when the user writes in another language.
- **Safety** — never commit/push without explicit approval; prefer reversible operations.
- **Agent Behavior** — inspect before editing, smallest change, verify, report honestly.
- **Engineering Preferences** — Conventional Commits, behavior-describing names, explicit contracts, simple over clever.

## Portability note

These 9 skills follow the open Agent Skills standard and work in any environment that supports `SKILL.md`. Two ZCode-only skills (`context-compact`, `session-handoff`) are intentionally not shipped here — they depend on ZCode-specific features (the `/compact` and `/clear` commands, the `ReadSessionContext` tool) — and live only in the `zcode/` folder.