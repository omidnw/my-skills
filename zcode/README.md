# ZCode — Skills & Instructions

Portable **Agent Skills** plus **instructions** for [ZCode](https://zcode.ai). ZCode has no separate rules files — rules live in `AGENTS.md` (per the platform design), which is loaded automatically at session start. Skills live in `.zcode/skills/` and load on demand.

## Install

**Per project (workspace)** — copy into your repo root:

```bash
cp -R zcode/.zcode .              # skills + hooks (config.json)
cp zcode/AGENTS.md .              # rules + instructions
```

**Global** — copy into your home directory:

```bash
cp -R zcode/.zcode/skills ~/.zcode/skills/
cp zcode/AGENTS.md ~/.zcode/AGENTS.md
```

ZCode also discovers skills from `.agents/skills/` at every level, and the workspace `AGENTS.md` is found by walking up from the working directory. Same-named skills are shadowed by the first in discovery order (user scope wins).

## Layout

```
.zcode/
├── skills/      11 Agent Skills (SKILL.md + references/ + scripts/) — loaded on demand
└── config.json  ZCode hooks (auto-approve plan proposals) — optional, see below
AGENTS.md        rules + instructions (Language, Safety, Agent Behavior, Engineering)
```

## Skills

| Skill | What it does | Why it was created |
|---|---|---|
| **code-quality** | Runs the project's installed formatters/linters/type-checkers against the files you changed, fixes, and re-runs — a static quality gate before declaring "done". | Stop claiming "done" while lint/type errors remain on touched files; stop scope-creep and config-silencing of violations. |
| **context-compact** | Measures own context fill against thresholds and adapts (read less, delegate, recommend `/compact`) so long sessions stay cheap and fast. | The user can't see token usage — the agent must self-regulate before heavy reads; a missed compaction costs more than the compaction itself. |
| **design-principles** | Full UI/UX playbook: design tokens, typography, spacing, motion, RTL mirroring, accessibility, dark theme — for calm, production-ready interfaces. | Recurring UI failures: `direction: rtl` without mirroring the layout, pure `#000`/`#FFF` dark themes, random colors, animation everywhere instead of on state changes. |
| **external-ai-consult** | Before heavy work, gets 2–5 de-risking questions answered by an external AI via a copy-paste block the user runs in their own AI tool. | Front-load knowledge instead of learning by costly trial-and-error; avoids vague "I need more info" dead-ends. |
| **parallel-subagents** | Splits large tasks into independent sub-agent tasks running in parallel without collision or duplication (artifact partitioning, exclusive write ownership, contract-first). | Parallel work disasters: two agents "fixing" the same bug differently, duplicate explorations, last-writer-wins silently losing work. |
| **reliable-execution** | Executes tasks the way the user expects: restate, decompose, stay in scope, gate irreversible steps, verify, report honestly. | Models that drift mid-task: coding before restating the task, "also fixing" unrelated issues, reporting success without verification. |
| **research-and-reuse** | Researches unfamiliar domain logic (sensors, DSP, crypto, ML…) from docs before implementing, and prefers maintained packages over hand-rolled code. | Domain-expert logic is full of subtle failure modes; a maintained package is exercised by thousands of users, a fresh implementation only by your tests. |
| **session-handoff** | Continues or pulls context from a previous ZCode session by ID (`#sess_...`). | Fake continuity — claiming to remember a previous session without an ID; dragging a whole session in when one fact was needed. |
| **sudo-handoff** | Hands privileged (root/admin) commands to the user in one copy-pasteable block instead of failing on sudo. | `sudo: a password is required` was treated as a dead-end; it's really a handoff signal — the user is the privileged shell, the agent the analyst. |
| **task-intake** | Turns a raw request into a structured brief (goal, context, constraints, acceptance criteria, verification) before anything executes. | Raw requests lack the context that tells the model which knowledge to load; vague asks get executed on hope; skipping acceptance criteria is where guessing starts. |
| **tauri-v2-docs** | Resolves exact Tauri v2 documentation pages (official `llms.txt` index) for APIs, config, permissions, and plugins. | Tauri v1 docs are a recurring trap — v1 examples silently break in v2 projects; a doc map prevents mixing v1 code into v2. |

> `context-compact` and `session-handoff` are ZCode-specific — they use ZCode's `/compact`/`/clear` commands and the `ReadSessionContext` tool — so they ship only in this folder.

## ZCode-specific extras: hooks

This folder also carries the author's personal ZCode hook setup in `.zcode/config.json`:

- **Auto-approve plan proposals** — a `PreToolUse` hook matching `ExitPlanMode` that approves plan-mode exits automatically, so a proposed plan is not paused on a permission prompt.

Install it by copying `.zcode/config.json` into your repo root (it is included in the `cp -R zcode/.zcode .` command above). ZCode requires `hooks.enabled: true` for config-file hooks, which this file sets. Remove the file — or set `"enabled": false` — if you prefer to review every plan proposal yourself.

## Rules (inside AGENTS.md)

- **Language** — always answer in English, even when the user writes in another language.
- **Safety** — never commit/push without explicit approval; prefer reversible operations.
- **Agent Behavior** — inspect before editing, smallest change, verify, report honestly.
- **Engineering Preferences** — Conventional Commits, behavior-describing names, explicit contracts, simple over clever.