---
name: research-and-reuse
description: >
  Research unfamiliar domain logic (sensors, signal processing, detection,
  audio DSP, crypto, networking, ML) BEFORE implementing — via web search /
  docs, and when that is not decisive, via a copy-pasteable external-AI
  consult (Google AI Studio / Gemini). Also prefer battle-tested npm packages
  over hand-rolled code so the app has fewer custom bugs. Use whenever a
  feature involves algorithm- or domain-expert code, when deciding between
  implementing something and depending on a package, when integrating an
  unfamiliar library, or when the user says things like "ask Google AI",
  "research this first", "use npm packages", "don't rebuild the wheel",
  "check how sensors work". Works in any codebase.
---

# Research First, Reuse Packages

## Purpose

Two behaviors that keep a codebase bug-light:

1. **Research before you implement.** Domain-expert logic (sensor processing,
   audio analysis, crypto, networking, ML) is full of subtle failure modes
   that change over time. Never write it from training-data memory — get the
   current, proven approach first.
2. **Reuse before you rebuild.** A well-maintained package has been exercised
   by thousands of real users; a freshly written implementation has only your
   tests. For non-trivial problems, depending on a package is the
   bug-reduction strategy, not a shortcut.

## When to use

- Adding or rewriting algorithm-heavy / domain-expert code (sensor or signal
  processing, pose/detection logic, audio DSP, crypto, media handling,
  network protocols, ML).
- Deciding between "implement it" and "use a package" for any feature.
- Integrating an unfamiliar library, API, or SDK (unknown flags, current
  versions, platform quirks).
- The user explicitly asks for research or package reuse ("ask Google AI",
  "research this first", "use npm packages", "don't rebuild the wheel").

## Preconditions

- If the session has a web-search tool, it can reach the official docs / npm
  pages. If it doesn't (or the answer needs current domain expertise), the
  user is willing to paste one copy-pasteable question block into Google AI
  Studio / Gemini and bring the answers back.

## Workflow

1. **Name the unknowns.** Write down the 2–5 sharp, self-contained questions
   that, if answered, would de-risk the implementation: which algorithm /
   package is the current best practice, exact API shapes, version numbers,
   stack constraints, known pitfalls.
2. **Research tier A — the web (when available).** Use WebSearch / WebFetch
   against official sources: the language's docs, the npm registry page, the
   library's GitHub README and docs, the maintainer's changelog. Read the
   actual docs; do not stop at search-result summaries.
3. **Research tier B — external AI consult (when tier A isn't decisive).**
   Hand the user a copy-pasteable `Questions:` block formatted exactly like
   the `external-ai-consult` skill (numbered self-contained questions +
   answer-format preamble, four-backtick outer fence). Pause and wait for the
   answers; do not start the algorithm work blind in the meantime.
4. **Search for a package before writing custom code.** On npm/GitHub, look
   for a maintained package that solves the problem. Evaluate it against the
   Rules below (maintenance, license, compatibility, weight).
5. **Decide: package vs custom.** Prefer the package unless the logic is
   trivial AND safe to hand-roll, or every candidate package is unmaintained /
   license-incompatible / too heavy for the need.
6. **Verify in this repo.** Add the dependency (pinned), build, and exercise
   the real code path: the project's typecheck / lint / tests, and the actual
   runtime flow. Proof it works here beats a README that says so.
7. **Record the choice.** Leave a short code comment and note the chosen
   package (or the reason a package was rejected) plus the research source in
   the change summary, so the next agent does not re-litigate it.

## Rules

- **Prefer an existing, maintained package over new code** for domain-expert
  logic (sensors, DSP, crypto, ML, media, networking). Do not rebuild the
  wheel.
- **Never copy package internals into the repo** — depend on the package so
  security/behavior updates flow in. (The one exception: small, clearly-
  licensed, vendored helper code with a comment saying where it came from.)
- **Check before adding a dependency:** last publish within ~1 year, sane
  weekly downloads, license compatible (MIT / Apache-2.0 / BSD / OFL fine;
  be careful with GPL/AGPL for a distributed or proprietary app), TypeScript
  types present or easy to add, compatible with the project's stack
  (framework/version; no bare Node built-ins on the frontend, no native
  addons in a Tauri-like guest unless packaged).
- **Pin the version.** No `^`-floating for anything the app depends on.
- **The global "fewer dependencies" principle still applies** — it is the
  tie-breaker between equivalent candidates, and it still forbids pulling a
  500 KB library for a 5-line need. Research-reuse never means dependency
  bloat.
- **Verify external info before relying on it.** AI answers, search snippets,
  and READMEs are unverified claims. Check the official docs and run the code
  in this repo's environment before trusting it.
- **If research contradicts existing code, surface it** — explain the
  discrepancy to the user instead of silently rewriting working behavior.

## Common mistakes

- Writing algorithm code from training-data memory (e.g. rolling your own
  heuristics) — subtle accuracy and battery bugs; research the current best
  practice and library first.
- Adding a stale or unmaintained package, then shipping a broken feature
  built on it.
- Picking a frontend package that imports Node built-ins — it fails the
  frontend build with confusing module errors.
- Copy-pasting a package's code into the repo to "avoid the dependency" —
  now the bug fixes never arrive.
- Trusting an AI answer or a package README without ever running the code.
- Over-engineering: pulling a large library when a tiny, maintained one (or a
  few lines of verified code) suffices.
- Ignoring license — shipping a GPL/AGPL dependency in a proprietary app.

## Validation

- The feature passes the project's checks: its typecheck, lint, and relevant
  test suites.
- The dependency exists in the manifest (e.g. `package.json`) with a pinned
  version and in the lockfile.
- The real code path actually ran (unit test or manual run of the feature),
  not just type-checked.
- The research step visibly happened: the change summary cites either a web
  source (official docs / npm page) or an external-AI consult that informed
  the implementation.
