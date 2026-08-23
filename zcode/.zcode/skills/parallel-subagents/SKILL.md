---
name: parallel-subagents
description: Split work into independent sub-agent tasks that do not collide or duplicate.
  Use whenever delegating to multiple agents, background tasks, or parallel exploration.
  Teaches artifact-based partitioning, exclusive write ownership, contract-first splitting,
  and self-contained prompts so parallel agents never interact or redo each other's work.
---

# Parallel Sub-Agents — Universal

## Purpose
Split a large task into sub-agent tasks that run in parallel without conflicting or
duplicating work. Each agent does exactly one job; no two agents share write ownership
of the same artifact; no two agents re-derive the same decision.

## When to use
- The task can be divided into several independent pieces (multiple files, searches, services).
- The work is large enough that one agent would serially take too long.
- Launching several agents or background tasks at once.

## Preconditions
- The task has been shaped by `task-intake` — goal, constraints, and acceptance criteria are known.
- The interfaces between pieces (signatures, data shapes, file paths) are defined before splitting.

## Workflow
1. **Decompose by artifact.** List the outputs (files, answers, artifacts). Assign one agent per output.
2. **Check for interaction.** For each pair of agents ask: would both *decide* something about the same file? would both write to the same path? If yes — merge them, or give one ownership and the other read-only access.
3. **Resolve shared unknowns once.** Any fact or decision two agents would both need (a design choice, an API shape, a convention) is settled now, before launching, and embedded in every affected prompt.
4. **Define contracts first.** If outputs must connect (a function and its caller), fix the contract signature before launch — agents then never coordinate mid-flight.
5. **Write self-contained prompts.** Each prompt carries: the deliverable, the source facts (file paths, exact requirements), the constraints (what not to touch), the acceptance criteria, and the verification. A sub-agent must be able to complete from its prompt alone.
6. **Launch in parallel.** Merge results only where the contracts say they connect.
7. **Verify per artifact.** Each sub-agent verifies its own deliverable; cross-check integration points yourself.

## Rules
- No two agents may own write access to the same file. Reading overlap is fine; writing or deciding overlap is not.
- Give each agent its own search scope (directories, keywords, questions) so explorations do not duplicate.
- Never launch a sub-agent whose prompt ends in a question — it must complete from its prompt alone.
- Merging and conflict resolution belong to the main agent, never to the sub-agents.

## Common mistakes
- Two agents fixing the "same" bug in different files because the duplication was not detected before splitting.
- Parallel exploration answering the same question twice with two different results.
- Overlapping write ownership — last-writer-wins silently loses work.
- Sub-agent prompts that require mid-task coordination ("wait until agent B finishes X").

## Validation
- The combined result contains each artifact exactly once, written by exactly one agent.
- No piece of work was done twice — run the duplicate check across the merged outputs.
- Each sub-agent completed without asking the main agent a question.