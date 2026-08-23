# Personal Agent Skills — for 6 coding environments

A public collection of **Agent Skills** and **engineering rules** derived from personal experience — pain points I actually ran into in real projects, turned into repeatable workflows and shared as-is, in the hope they save you the same trial-and-error. Every skill follows the open **Agent Skills** standard (`SKILL.md` with YAML frontmatter, optional `references/` and `scripts/`), so the same content works across every environment that supports it.

Everything is in **English**; each environment's rules include the always-English rule.

> These are my **personal** skills — they have worked well for me, and that's why I made them public. I have no interest in publishing them on openskills.cc or any other skill marketplace; this repository is their only home.

## Supported environments

| Environment                            | Folder                   | Skills live in      | Rules live in                               |
| -------------------------------------- | ------------------------ | ------------------- | ------------------------------------------- |
| [Claude Code](https://code.claude.com) | [`claude/`](claude/)     | `.claude/skills/`   | `.claude/rules/*.md` + `CLAUDE.md`          |
| [Cursor](https://cursor.com)           | [`cursor/`](cursor/)     | `.cursor/skills/`   | `.cursor/rules/*.mdc` (alwaysApply)         |
| [Kiro](https://kiro.dev)               | [`kiro/`](kiro/)         | `.kiro/skills/`     | `.kiro/steering/*.md`                       |
| [ZCode](https://zcode.ai)              | [`zcode/`](zcode/)       | `.zcode/skills/`    | `AGENTS.md` (no separate rules files)       |
| [OpenCode](https://opencode.ai)        | [`opencode/`](opencode/) | `.opencode/skills/` | `AGENTS.md`                                 |
| ChatGPT (Codex)                        | [`chatgpt/`](chatgpt/)   | `.agents/skills/`   | `AGENTS.md` (+ `~/.codex/AGENTS.md` global) |

> **Note on ChatGPT:** "ChatGPT Work Code" is not a separate product — the coding agent behind ChatGPT Work / desktop / the CLI is **Codex**. Its native conventions are `.agents/skills/` and `AGENTS.md`, which is what the `chatgpt/` folder contains.

> **Note on coverage:** `zcode/` ships all 11 skills, plus the author's ZCode hooks config (`.zcode/config.json` — auto-approves plan proposals). The other five environments ship the **9 portable** skills — `context-compact` and `session-handoff` are **ZCode-only** (they depend on ZCode's `/compact`/`/clear` commands and the `ReadSessionContext` tool) and would do nothing useful elsewhere.

## How to use

Pick one environment folder, then either:

1. **Per project** — copy the folder's contents into your repo root (the exact commands are in each folder's `README.md`).
2. **Global** — copy the skills into your user skills directory (e.g. `~/.agents/skills/`, `~/.claude/skills/`, `~/.cursor/skills/`, `~/.kiro/skills/`).
3. **Import from the IDE** — most environments can import a skill from a GitHub repo URL or local folder (Kiro and Cursor ship UI for this).

Skills fire automatically when a request matches their `description`; most can also be invoked manually (`/` in many clients, `@` in ChatGPT, `$`/`/skills` in Codex).

## Not technical? Let your coding agent set it up

No terminal, no worries — open **[`agent-help.md`](agent-help.md)**, pick the app you use (Claude Code, Cursor, Kiro, ZCode, OpenCode, or Codex/ChatGPT), and paste that app's prompt into its chat. The agent fetches this repository and installs everything for you automatically, then walks you through what it did.

## The skills

| Skill                            | What it does                                                                                                                              | Why it was created                                                                                                                                             |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **code-quality**                 | Runs installed formatters/linters/type-checkers against the files you changed, then fixes and re-runs.                                    | "Done" was being claimed while lint/type errors remained on touched files; scope creep and config-silencing crept in.                                          |
| **context-compact** (ZCode-only) | Measures own context fill against thresholds and adapts (read less, delegate, recommend `/compact`) so long sessions stay cheap and fast. | The user can't see token usage — long sessions bloated silently; a missed compaction costs more than the compaction itself.                                    |
| **design-principles**            | Full UI/UX playbook: tokens, typography, spacing, motion, RTL mirroring, a11y, dark theme.                                                | Recurring failures: `direction: rtl` without layout mirroring, pure `#000`/`#FFF` dark themes, random colors, motion without meaning.                          |
| **external-ai-consult**          | Gets 2–5 de-risking questions answered by an external AI before heavy work.                                                               | Learning by costly trial-and-error; vague "I need more info" dead-ends that waste a turn.                                                                      |
| **parallel-subagents**           | Splits large tasks into independent sub-tasks that run in parallel without collision or duplication.                                      | Two agents "fixing" the same bug differently, duplicate explorations, last-writer-wins silently losing work.                                                   |
| **reliable-execution**           | Forces restating, decomposing, scoping, verifying, and honest reporting before a task is declared done.                                   | Models drifting mid-task: coding before understanding, "also fixing" unrelated stuff, reporting success without verification.                                  |
| **research-and-reuse**           | Researches unfamiliar domain logic from docs first; prefers maintained packages over hand-rolled code.                                    | Domain code is full of subtle failure modes; a maintained package is exercised by thousands, a fresh implementation only by your tests.                        |
| **session-handoff** (ZCode-only) | Continuation across sessions via session ID (`handoff` vs `relevant` strategies).                                                         | Fake continuity — claiming to remember a session without an ID; pulling whole sessions for a single fact.                                                      |
| **sudo-handoff**                 | Hands privileged commands to the user in one copy-pasteable block instead of failing on sudo.                                             | `sudo: a password is required` treated as a dead-end instead of a handoff signal; unverifiable command chains, password embedding.                             |
| **task-intake**                  | Turns a raw request into a structured brief (goal, context, constraints, acceptance criteria, verification).                              | Vague asks executed on hope; skipping acceptance criteria is where the model starts guessing.                                                                  |
| **tauri-v2-docs**                | Resolves exact Tauri v2 doc pages via the official `llms.txt` index (APIs, config, permissions, plugins).                                 | Tauri v1 examples silently break in v2 projects; a doc map keeps v1 code out of v2.                                                                            |

## Rules included everywhere

1. **Language** — always answer in English, even when the user writes in another language.
2. **Safety** — never commit/push/PR without explicit approval; prefer reversible operations for destructive actions.
3. **Agent behavior** — inspect before editing, smallest change, match existing patterns, verify, report honestly.
4. **Engineering preferences** — Conventional Commits, behavior-describing names, explicit contracts, simple over clever.

## Maintenance

`skills/` is the **canonical source of truth** — edit a skill there, then re-sync every environment copy:

```bash
./scripts/sync-skills.sh
```

Rules, instruction files (`CLAUDE.md` / `AGENTS.md`), and READMEs are per-environment because each platform formats them differently; the 9 portable skills are byte-identical everywhere, and `zcode/` additionally carries its 2 ZCode-only skills.

## Portability notes

- All skills use the standard `SKILL.md` format; `code-quality` originally had no frontmatter and received one in this repo so every environment can discover it.
- `context-compact` and `session-handoff` are **ZCode-only** — they depend on ZCode's `/compact`/`/clear` commands and the `ReadSessionContext` tool — and are shipped only in `zcode/`. The other 9 skills are portable and ship in every environment.
- Personal paths were removed in the public copies: `external-ai-consult` is fully manual — it has no dependency on any local tool.
- Licensed under the **MIT License** — see `LICENSE`.

## Contact

Found these useful, or want to get in touch?

- 📧 Email: omidrezakeshtkar@icloud.com
- GitHub: [github.com/omidnw](https://github.com/omidnw)
- LinkedIn: [Omid Reza Keshtkar](https://www.linkedin.com/in/omid-reza-keshtkar/)

## More skills

Looking for more (and often better) Agent Skills? [openskills.cc](https://openskills.cc) is a great place to browse community skills — a good resource when you want to go beyond this collection. Note: this collection is not published there; it lives only in this repository.
