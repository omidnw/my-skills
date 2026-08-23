---
name: context-compact
description: >
  Measure your own context fill, compare it against budget thresholds, and
  adapt (read less, delegate to subagents, recommend /compact) so long
  sessions stay cheap and fast. Use automatically before starting a task on
  a long conversation, after reading large files, or whenever context feels
  heavy — triggers: "context", "compact", "/compact", "token", "token
  usage", "context size", "heavy/cluttered/long context", "keep it light"
  (in any language the user speaks). Implements the
  auto-compact concept (budget → fill ratio → mode → adapt), the same idea
  as lilith's adaptive context engine.
---

# Context Compact

## Purpose

Prevent context bloat and cut token consumption by measuring how full the
context window is, comparing it to thresholds, and adapting reading and
delegation behavior *before* it becomes a problem. When fill gets high,
compact what you can and tell the user to run `/compact` (or `/clear` when
the task is done).

## When to use

Trigger **automatically** when any of these holds:

- The conversation is long (10+ turns) or the user mentions "context",
  "compact", "/compact", "token"/"token usage", "context size",
  "heavy/cluttered/long context", or asks to "keep it light" — in any
  language the user speaks.
- About to read a file you suspect is large (> 300 lines) or whose size you
  don't know yet.
- Right after reading a large file while the task continues.
- The user mentions token usage, cost, or session speed.

- The user just approved a plan and implementation is about to start
  (plan-gated compact — see Rules).

Do **not** trigger for trivial single-file lookups on a fresh session.

## Preconditions

- None hard. The estimation method below is a heuristic — no tokenizer needed.

## Workflow

1. **Estimate the budget.** The active model supports 600K/1M-token windows —
   use the known window (600K default, 1M when set). Reserve ~20% for system
   prompt + tool output.
2. **Estimate current fill.** Sum of: system instructions (AGENTS.md files),
   files fully read this session (byte size ÷ 4 ≈ tokens, or line count × ~11),
   tool outputs still in context, and the conversation itself. Rough is fine —
   you only need the right *band*.
3. **Compare → mode** using the table in Rules.
4. **Adapt per mode.** Change how you read and delegate before doing anything
   else.
5. **Compact when heavy (fill > 70% — or the absolute cap in step 6).**
   Re-express what you still need as short notes; stop holding full file
   contents in context; explicitly recommend `/compact` to the user (and
   `/clear` when the task is done).
6. **Absolute cost cap.** When estimated context exceeds **500K tokens**,
   recommend `/compact` immediately — regardless of percentage bands. The
   goal is cutting token cost, so trigger early, not at the window edge.
7. **Sensitive-work exception.** Do NOT recommend compaction during
   data-loss-risk, security, irreversible-operations, or state-heavy
   debugging work — losing detail can change the outcome. Keep full context
   and state the tradeoff explicitly.
8. **Preserve thread and plan.** Immediately before recommending
   `/compact`/`/clear`, write a 2–4 line handoff note (current task • plan •
   decisions • next steps) so the summary retains the thread.
9. **Report.** One line to the user about the mode and what you changed, so
   the recommendation is visible: e.g. `mode: balanced (~55% fill)`.

## Rules

| Fill | Mode | Behavior |
|---|---|---|
| < 40% | expansive | Full reads fine; normal workflow |
| 40–50% | balanced | Prefer offset/limit reads and grep; delegate broad searches to subagents |
| > 50% | lean | Recommend `/compact` at a natural stopping point; reduce full-file holds |
| > 70% | constrained | grep-only for new files; subagents for everything; recommend `/compact`; no new large reads without telling the user |
| > 500K tokens (absolute) | cost-cap | Recommend `/compact` immediately, bands ignored; write the handoff note first; never during sensitive work |

- ≈ 4 characters ≈ 1 token for mixed code + text (code is denser; count
  bytes ÷ 3 as a safe upper bound).
- A full `Read` permanently adds the file to context — prefer `Read` with
  offset/limit, or `grep`, when a section suffices.
- Multi-file searches always go to a subagent (`Agent`), never inline.
- When you summarize/drop a file, never later quote its exact code as if it
  is still loaded — re-read only the needed lines.
- At > 70% fill, never open a large file silently: state the cost first.
- **Plan-gated compact**: once the user approves a plan, recommend `/compact`
  before implementation starts. The exploration context collapses into the
  plan summary; the handoff note is the plan itself, so only the noise is
  lost. Still respects the sensitive-work exception.

## Compact handoff (delivering `/compact`)

The agent never runs `/compact` itself — the user does. Deliver it exactly
like a privileged command (the `sudo-handoff` pattern):

1. **State the trigger.** One line: `context > 500K tokens — cost-cap` (or `fill > 70% — heavy`).
2. **Write the handoff note** (2–4 lines: current task • plan • decisions •
   next steps) as the LAST content of your message — that's what the
   `/compact` summary preserves.
3. **Give the copy-pasteable command** in a fenced block:
   ```
   /compact
   ```
   Preceded by one sentence of what it does and why it's needed.
4. **Wait.** Do not start new heavy reads while the user runs it.
5. **Resume from the note** once the user confirms. Never assume it ran.

Rules:
- The note must be the last thing you write — the summary keeps the tail of
  the conversation.
- Never deliver a handoff during sensitive work (see Workflow step 7).
- If the user declines, keep working in constrained mode — don't nag
  repeatedly.

## Common mistakes

- Counting only the *last* message — context is cumulative since the session
  started.
- Reading a whole file when grep + offset/limit would do (the biggest waste
  by far).
- Silently continuing after heavy reads instead of recommending `/compact` —
  the user can't see your token usage.
- Summarizing a file but then still referencing its exact contents (it's
  gone — you must re-read).
- Treating this skill as optional because "the AGENTS.md already has context
  rules" — this is the *procedure* for those rules; the rules are the
  thresholds, this is the loop.
- Recommending `/compact` during sensitive work (data-loss risk, security,
  irreversible ops, state-heavy debugging) just to save tokens.
- Crossing 500K tokens without telling the user that every further read is
  expensive — a missed compaction makes each re-read costlier than the
  compaction itself.

## Validation

- Before a task on a long session, state the band in one line, e.g.
  `mode: balanced (~55% fill)` — a human can sanity-check the estimate.
- After compacting, the session should feel lighter: the next user turn
  should show a smaller working set (fewer large reads).
- The user confirms the `/compact` recommendation was made when fill crossed
  70% — if a heavy session never got a recommendation, this skill was skipped.
- If a session crossed 500K tokens and no `/compact` was recommended (and the
  work wasn't sensitive), the cost-cap rule was skipped.
- A handoff note exists right before every `/compact`/`/clear` recommendation,
  so the thread and plan survived the summary.
- The user confirms `/compact` ran, and you resume from the pre-written note
  rather than from memory.
