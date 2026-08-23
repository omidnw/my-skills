---
name: task-intake
description: Turn a raw user request into a well-formed task brief before anything is executed.
  Use when a request is vague, under-specified, or missing context, and when the model must
  load the correct knowledge from its knowledge base. Restructures the request into goal /
  context / constraints / acceptance criteria so the model picks the right approach and
  activates the right knowledge.
---

# Task Intake — Universal

## Purpose
Shape the input before execution. A raw request usually lacks the context that tells the
model which knowledge to load — so intake converts it into a structured brief: goal,
relevant context, constraints, acceptance criteria, verification. The brief dictates
what knowledge gets activated and what the output must look like.

## When to use
- The request is vague, one-line, or missing constraints ("make this better", "fix it", "build the thing").
- The task sits in a domain with many valid approaches (styling, architecture, APIs, algorithms).
- The request implies knowledge that was never stated (framework versions, project conventions, existing patterns).

## Preconditions
- The raw request is available to re-read — never shape from memory of it.
- The repo is inspectable to fill context that the request did not state.

## Workflow
1. **Extract the goal.** What must be true when the work is done? If the request does not say, that is the first gap to close.
2. **Identify missing context that changes the approach** — stack, versions, existing patterns, constraints, intended users.
3. **Classify each gap:** already stated / discoverable in the repo / must ask the user.
4. **Fill what the repo answers.** Inspect code and docs before asking anything.
5. **Ask only for gaps the repo cannot answer and that change the outcome** — one focused question, not a questionnaire.
6. **Write the brief:** Goal · Context loaded (the facts that drive the approach) · Constraints (what not to touch) · Acceptance criteria (how we know it is done) · Verification.
7. **Execute the brief** through the `reliable-execution` workflow.

## Rules
- Never execute from the raw request alone — always from the brief.
- Load facts from the repo before asking the user; ask only for what the repo cannot answer.
- The brief must name acceptance criteria — without them every output is equally "done".
- Keep the brief to a few lines. It is a working contract, not documentation.

## Common mistakes
- Executing a vague request as-is and hoping ("improve" without defining what improvement means).
- Asking the user questions the repo already answers.
- Writing a brief that restates the request instead of adding missing context and constraints.
- Skipping acceptance criteria — this is the point where the model starts guessing.

## Validation
- Execution contained no step that said "I assumed…" — every decision traced to the request, the repo, or a user answer.
- The brief drove the execution; every statement in it traces to a source.
- Executing from the brief alone (without the raw message) reproduces the same outcome.