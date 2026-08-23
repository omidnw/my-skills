# Agent Help — let your coding agent set this repo up for you

No terminal? No problem. Pick the coding app you use below, copy its prompt, and paste it into the app's chat box. The agent will fetch this repository, install the skills and rules into your project, and walk you through what it did.

**The repository:** https://github.com/omidnw/my-skills

## How it works

1. Copy the prompt under the name of your app (one click).
2. Open the app and paste the prompt into a chat — in a new project or one you already have open; both work.
3. Allow the actions it asks permission for (cloning the repo, creating files, running setup).
4. Done. The agent installs everything and shows you a plain-language summary.

> If it asks whether to install **per project** or **globally**, choose **per project** to keep things contained. Choose global only if you want these skills available in all your projects — the agent will tell you which files go where.

---

## Claude Code

Copy this into Claude Code:

```text
Set up this repository for me: https://github.com/omidnw/my-skills

Clone it into a temporary folder, then install the Claude Code setup from it
into my current project:

1. Copy claude/.claude/skills -> .claude/skills/ (all skill folders inside)
2. Copy claude/.claude/rules -> .claude/rules/ (the always-loaded rules)
3. Copy claude/CLAUDE.md -> the project root

Then verify the skills and rules are in place, and summarize what you
installed in simple, non-technical language (what the skills do, one line
each). Explain any step you need me to approve before you do it.
```

---

## Cursor

Copy this into Cursor's Agent chat:

```text
Set up this repository for me: https://github.com/omidnw/my-skills

Clone it into a temporary folder, then install the Cursor setup from it
into my current project:

1. Copy cursor/.cursor/skills -> .cursor/skills/ (all skill folders inside)
2. Copy cursor/.cursor/rules -> .cursor/rules/ (the .mdc always-applied rules)

Then verify the skills were discovered and the rules are in place, and
summarize what you installed in simple, non-technical language (what the
skills do, one line each). Explain any step you need me to approve before
you do it.
```

---

## Kiro

Copy this into Kiro's chat:

```text
Set up this repository for me: https://github.com/omidnw/my-skills

Clone it into a temporary folder, then install the Kiro setup from it
into my current project:

1. Copy kiro/.kiro/skills -> .kiro/skills/ (all skill folders inside)
2. Copy kiro/.kiro/steering -> .kiro/steering/ (the always-loaded steering files)

Then verify the skills and steering files are in place, and summarize what
you installed in simple, non-technical language (what the skills do, one
line each). Explain any step you need me to approve before you do it.
```

---

## ZCode

Copy this into ZCode's chat:

```text
Set up this repository for me: https://github.com/omidnw/my-skills

Clone it into a temporary folder, then install the ZCode setup from it
into my current project:

1. Copy zcode/.zcode/skills -> .zcode/skills/ (all skill folders inside,
   including the two ZCode-only ones: context-compact and session-handoff)
2. Copy zcode/AGENTS.md -> the project root (this holds the rules —
   ZCode has no separate rules files)
3. Optionally copy zcode/.zcode/config.json -> .zcode/config.json
   (a hook that auto-approves plan proposals — explain what it does and
   let me decide whether to keep it)

Then verify the skills are in place, and summarize what you installed in
simple, non-technical language (what the skills do, one line each).
Explain any step you need me to approve before you do it.
```

---

## OpenCode

Copy this into OpenCode's chat:

```text
Set up this repository for me: https://github.com/omidnw/my-skills

Clone it into a temporary folder, then install the OpenCode setup from it
into my current project:

1. Copy opencode/.opencode/skills -> .opencode/skills/ (all skill folders inside)
2. Copy opencode/AGENTS.md -> the project root (this holds the rules)

Then verify the skills are in place, and summarize what you installed in
simple, non-technical language (what the skills do, one line each).
Explain any step you need me to approve before you do it.
```

---

## Codex / ChatGPT

Copy this into ChatGPT (Codex), the Codex CLI, or the Codex IDE extension:

```text
Set up this repository for me: https://github.com/omidnw/my-skills

Clone it into a temporary folder, then install the Codex setup from it
into my current project:

1. Copy chatgpt/.agents/skills -> .agents/skills/ (all skill folders inside)
2. Copy chatgpt/AGENTS.md -> the project root (this holds the rules)

Then verify the skills are discovered, and summarize what you installed in
simple, non-technical language (what the skills do, one line each).
Explain any step you need me to approve before you do it.
```

---

## What you get

Whichever app you used, you end up with the same thing — the author's personal Agent Skills and engineering rules working in that app:

- **Skills** that activate automatically when a task matches them (linting your code, researching unfamiliar topics before coding, splitting big work across agents, handing you privileged commands instead of failing, and more).
- **Rules** applied in every session (always answer in English, never commit without your approval, inspect before editing, keep changes small, and the rest).

If anything asks for permission you don't recognize, ask the agent to explain it first — it should always tell you before acting.