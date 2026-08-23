---
name: sudo-handoff
description: Hand privileged (root/admin) commands to the user to run, instead of failing on sudo. Use whenever the agent needs sudo/root/elevated privileges — "sudo", "root", "password required", "needs admin", "EACCES", "permission denied", pfctl/launchctl/systemd as root, restarting a root daemon, privileged installs — or when the user asks to be given the command to run and paste back the output.
---

# Sudo Handoff

## Purpose

When a task needs root privileges and the agent has no passwordless sudo, the correct move is NOT to give up or silently skip the step. It is to **hand the exact command to the user in a code block, wait for them to run it and paste the output, then continue**. The user is the privileged shell; the agent is the analyst.

## When to use

- Any command that returns `sudo: a password is required` (this is the trigger, not a dead end).
- Any operation that structurally needs root: binding privileged ports, `pfctl` anchor load/inspect, `launchctl bootstrap/bootout` in the system domain, restarting a root daemon, editing system files, privileged installs.
- The user explicitly says: "give me the command to run" / "run it and paste the output" (or the equivalent in the user's language).

## Preconditions

- The command you hand over must be **complete and self-contained** — absolute paths, no reliance on the agent's shell state, no `cd` chains.
- You must be able to say what the command does and why it is needed in one or two sentences.

## Workflow

1. **Detect the need.** `sudo -n` fails with "a password is required", or the task's nature requires root.
2. **Do not** retry `sudo -n` in a loop or declare the task blocked.
3. **Prepare one command.** Single command, absolute paths, properly quoted. Prefer the simplest command that answers the question — split compound `sudo bash -c '...'` into a single obvious command when possible.
4. **Present it to the user** as a fenced code block, preceded by one short sentence of what it does and why it's needed. In this project that is always English.
5. **Wait.** The user runs it and pastes the output back.
6. **Interpret and continue.** Read the pasted output, extract the fact you needed (e.g. anchor rules present/absent, exit code, service label), and proceed with the task.
7. If the output shows a problem, hand a follow-up command and iterate.

## Rules

- **"a password is required" is a handoff signal, never a failure.** Say "I need you to run this:" and give the command.
- **One command at a time.** Multiple `sudo` calls in one line obscure which one failed; the user can't see your intent. If several steps are needed, run them one handoff at a time.
- **Absolute paths, no shell state.** `/Users/.../siteblocker` not `./siteblocker`; the user's shell starts in an unknown directory.
- **Explain before you ask.** The user should never run a privileged command blind. One sentence: what it does, why it's needed.
- **Never embed the user's password in a command.** Their own `sudo` prompts them.
- **Prefer reversible/inspectable commands.** `pfctl -s` / `-a ... -s nat` (read) over mutating rules without review; state what a mutating command changes.
- If the task genuinely can't proceed without root and the user is unavailable, say exactly what is blocked and what command would unblock it — don't silently skip it.

## Common mistakes

- Treating `sudo: a password is required` as "can't do it" and ending the task.
- Retrying `sudo -n` hoping it magically works.
- Handing `sudo bash -c 'complex; chain; of; commands'` — the user can't verify it and the output is ambiguous. Prefer one clear command.
- Assuming the user's working directory or environment matches the agent's.
- Forgetting to say WHY — the user pastes output blindly and can't help interpret it.
- Handing a destructive command (delete, bootout, restore) without stating what it changes or that it's reversible.

## Validation

- The user runs the command and pastes output containing the expected marker (exit code, a rule line, a status string, a file listing).
- You confirm the output answers the question and continue the task; if the output is unexpected, ask for the corrected command's output.
- A handoff is only "done" when the user's pasted output confirms the effect — never assume it ran.
