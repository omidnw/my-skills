---
name: reliable-execution
description: Execute tasks the way the user expects — plan before acting, stay in scope,
  verify before reporting. Load before any non-trivial task, when a session is long, or
  when a model tends to drift. Forces task restatement, step decomposition, scope checks,
  and honest reporting so the delivery matches the request.
---

# Reliable Execution — Universal

## Purpose
Turn any request into an on-scope, verifiable delivery. Especially valuable for models
that tend to drift mid-task: it forces restatement, decomposition, scope discipline,
and honest reporting.

## When to use
- Before starting any task that involves more than a one-line change.
- When the request is ambiguous, large, or spans multiple files.
- When the session is long and drift risk is high.

## Preconditions
- The original request is available to re-read (do not rely on memory of it).
- Verification commands for the project are known or discoverable (package.json scripts, Makefile, CI config).

## Workflow
1. **Restate the task in one sentence.** If you cannot restate it, re-read the request before doing anything. For vague or under-specified requests, run the `task-intake` skill first to build the brief.
2. **Name the deliverable.** Write down what "done" looks like.
3. **Decompose into steps.** Break the work into the smallest number of concrete steps that cover the whole request; order them.
4. **Gate each step.** Small and reversible → execute. Large or irreversible → stop and get explicit approval.
5. **Execute in scope.** Only what was asked. Note unrelated findings separately; do not fix them.
6. **Re-read the original request.** Check off every requirement; complete anything missing.
7. **Verify.** Run the relevant checks (typecheck, lint, tests, or a manual test of the affected flow).
8. **Report.** What changed, what was verified, what failed or is uncertain — in that shape.

## Rules
- Ambiguity that changes the outcome → ask. An obvious, safe, reversible default → proceed and state it.
- Never add unrequested work to the delivery; report it as a separate note.
- Prefer the smallest change that satisfies the requirement; preserve existing behavior.
- Never present unverified work as done. If you could not verify, say so plainly.
- Reversible bias: prefer additive changes over replacements; backup before irreversible operations.

## Common mistakes
- Starting to code before restating the task — this is where drift begins.
- "Also fixing" unrelated issues noticed along the way.
- Reporting success without running verification.
- Asking the user when the default is obvious — wastes their time.
- Expanding scope to make the solution "nicer" instead of delivering what was asked.

## Validation
- The final report maps 1:1 to the original request.
- Every "done" claim is backed by a verification step.
- No file outside the request was modified.
