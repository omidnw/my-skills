---
name: external-ai-consult
description: >
  Before starting a heavy or complex task, proactively identify the few
  specific questions that would unblock or de-risk the work, and get them
  answered by an external AI — by handing the user a copy-paste block to
  run in Google AI Studio / Gemini / Claude / ChatGPT and paste the
  answers back. Use whenever a task looks involved and you're not
  already certain of every step — missing tool flags, undocumented
  behavior, platform quirks, API specifics, current versions, or the
  best approach overall. The goal is to save time and tokens by
  front-loading knowledge instead of learning by costly trial-and-error.
  Trigger automatically when a task is non-trivial and you'd otherwise
  be guessing; the user may also request it explicitly with phrases like
  "go research this first", "AI consult", "help me help you", or "figure
  this out elsewhere".
---

# External AI Consult

## Purpose

This skill **saves time and tokens** by front-loading knowledge.
Instead of guessing your way through a heavy task and burning compute
on failed attempts, you gather the key unknowns *upfront* by getting
them answered by an external AI. You identify 2–5 sharp, self-contained
questions and hand the user a single copy-paste block; they run it in
their preferred AI tool and paste the answers back into the chat.

The shift in mindset: **ask before you sink time, not after you fail.**

## When to trigger (automatic detection)

Trigger this skill **before starting serious work** when a task is
non-trivial AND you are not already confident about the whole path.
Concretely, trigger when **either** of these holds:

1. **The task is heavy or complex** — multi-step, architecturally
   significant, touches unfamiliar tooling, or would otherwise involve
   real trial-and-error. Examples:
   - Configuring system-level tools (firewalls, networking, kernel).
   - Integration work with an unfamiliar API, SDK, or framework.
   - Migration, build pipeline, or deployment setup.
   - Anything where a wrong early assumption cascades into rework.

2. **You have concrete unknowns** you can name right now:
   - You need **current/accurate** info (latest version, current API
     shape, platform-specific behavior) you don't trust your memory on.
   - There's **undocumented or obscure** behavior you'd otherwise learn
     the hard way (specific flags, edge cases, OS quirks).
   - You're **unsure which approach is best** among several options.

If the task is simple, routine, or you already know the full path with
confidence — **do not trigger**. Just do the work.

## How many questions, and how sharp

- Aim for **2–5 questions** — enough to de-risk the work, few enough
  for one trip to the external AI.
- Each question must be **specific and self-contained**: the external AI
  must be able to answer it without seeing your conversation. There is
  no follow-up conversation — pack everything each question needs into
  the question itself.
- Include the concrete details that matter: tool/library name and
  version, OS, the exact goal, the exact error text if there is one.

## Deliver as a plain text block, never a tool

**Do NOT use the `AskUserQuestion` tool** (or any modal/prompt tool) to
deliver the questions. Those render as clickable UI widgets that
**cannot be copy-pasted**, which defeats the whole point.

Output the questions as **ordinary markdown text** in your normal reply.
The copy-pasteable block must contain **two parts**: an
**answer-format preamble** (tells the external AI how to shape its
reply) and the **numbered questions**. Both parts go into the same
block, so the user copies the whole thing in one shot.

The exact shape (note the outer fence is four backticks so the inner
``` fences show up cleanly when pasted):

````
Questions:
For each question below, answer with this structure:
- Number each answer to match its question (Q1 → A1, Q2 → A2, ...).
- Lead with the direct answer in one or two sentences — no preamble.
- Put any commands, config, or code in fenced ``` blocks.
- Call out version-specific or OS-specific caveats inline.
- Be concise. If you are not sure, say "unsure" rather than guessing.

1. <self-contained question one>
2. <self-contained question two>
3. <self-contained question three>
````

Keep it plain and copy-pasteable. Surround with a brief instruction so
the user knows what to do, e.g.:

> This task looks involved and I want to get the key things right the
> first time. Please copy the block below, paste it into Google AI
> Studio (aistudio.google.com) or your preferred AI tool, and paste the
> answers back. Then I'll proceed.

Keep the tone helpful, not demanding. The user is doing you a favor.

### Why the answer-format preamble matters

Without it, external AIs tend to return prose essays or bury commands in
paragraphs, which is painful to map back onto your plan. With it, you
get back **numbered, command-ready answers** that line up 1:1 with your
questions — so when the user pastes them back, you can fold each answer
straight into the matching step of your plan.

## Workflow

1. **Recognize** the task is non-trivial and you have nameable unknowns.
2. **Formulate** 2–5 sharp, self-contained questions.
3. **Show them briefly** in chat so the user sees exactly what is being
   asked, then present the `Questions:` block as plain text (exactly as
   above) with a short instruction, and pause for the user to return
   with the answers.
4. **Resume**: read the returned answers carefully, fold them into your
   plan, and proceed. Only ask for another consult if the answers
   surface genuinely new unknowns that also meet the trigger criteria.

## If the user declines or has no time

If the user says "just do it" or declines, drop the consult and proceed
using your best judgment. Do not re-suggest unless the situation
genuinely worsens (e.g. you hit an error that proves a consult would
have helped).

## Example interaction

**Task: set up pfctl port forwarding on macOS.**

1. You formulate three sharp questions (macOS version, exact pfctl
   anchor/rules, the "Permission denied" gotcha, persistence across
   reboots).
2. You present the copy-paste block:

````
Questions:
For each question below, answer with this structure:
- Number each answer to match its question (Q1 → A1, Q2 → A2, ...).
- Lead with the direct answer in one or two sentences — no preamble.
- Put any commands, config, or code in fenced ``` blocks.
- Call out version-specific or OS-specific caveats inline.
- Be concise. If you are not sure, say "unsure" rather than guessing.

1. On macOS Sequoia 15.x, what is the correct way to use pfctl to forward traffic from port 8080 to port 80 on the same machine? Include the exact anchor/rules and the load command.
2. Why does 'sudo pfctl -f /etc/pf.conf' fail with 'Permission denied' even under sudo on recent macOS, and how is it resolved?
3. How do I make a pfctl rule persist across reboots on macOS?
````

3. The user pastes back the numbered answers; you fold each one into
   the matching setup step and proceed.

## Why this approach

- **Saves tokens** — avoids long loops of failed attempts.
- **Saves time** — one trip answers everything at once; the user runs
  the block on their side in seconds.
- **Respects the user** — no vague "I need more information."
- **Non-blocking** — the user can always decline and you continue with
  your best judgment.