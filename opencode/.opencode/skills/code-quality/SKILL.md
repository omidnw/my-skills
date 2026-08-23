---
name: code-quality
description: Run a project's installed formatters, linters, and type-checkers against the files you actually changed, then fix and re-run — a static quality gate before a change is declared done. Trigger automatically after editing source files, or when the user asks to lint, type-check, format, or verify changes.
---

# Skill: code-quality

Automatically run a project's installed formatters, linters, and type-checkers against changed files, then report and fix issues — **without running the application itself.** Acts as a built-in quality gate so type errors, lint violations, and formatting drift are caught before a change is declared done.

## When to trigger

Trigger this skill **automatically** after editing source files in any project that has formatters/linters/type-checkers installed, before reporting "done" or "fixed". Also trigger on explicit requests like:

- "check the project" / "lint this" / "type check" / "format the code"
- "run quality checks" / "make sure it builds" / "is it clean?"
- "verify my changes" / "what did I break?"

The goal: **never claim a change is complete while lint or type errors still exist on the touched files.** Detection is mandatory before running anything — do not assume a tool exists just because the project is in a given language.

## Core workflow

Follow these steps in order. The whole loop is: **detect → run → read → fix → re-run.**

### 1. Detect language and installed tools

Look at the project root for the real source of truth — never assume. Quick checklist:

- `package.json` → Node.js. Read it to see which of these are in `devDependencies`/`scripts`: `prettier`, `eslint`, `typescript` (or `tsc`). Also check for config files: `.prettierrc*`, `eslint.config.*`, `.eslintrc*`, `tsconfig*.json`.
- `pyproject.toml` / `setup.cfg` / `requirements*.txt` → Python. Look for `black`, `ruff`, `mypy`, `isort`, `flake8`.
- `go.mod` → Go (`gofmt`, `go vet`).
- `Cargo.toml` → Rust (`cargo fmt`, `cargo clippy`).

For details on detection and edge cases, read **`references/detection.md`**.

### 2. Route to the language module

After detecting the language, read the matching reference for the exact, project-respecting commands:

- **Node.js** → `references/nodejs.md`
- **Python** → `references/python.md`
- (Other languages: follow the same pattern — prefer the project's own npm/pip/scripts over global commands.)

Only read the reference you actually need; don't load all of them.

### 3. Run checks on the changed files

Critical rule: **scope checks to the files you actually touched.** Running `eslint .` or `tsc` on a huge repo is slow and floods the output with pre-existing errors you didn't cause. Pass explicit file paths to formatters/linters. Type-checkers that are whole-program (like `tsc --noEmit`) run at project scope by necessity — that's fine, but filter the output to the files/areas you changed when deciding what's "yours" to fix.

Prefer the project's own script aliases (`npm run lint`, `npm run typecheck`) when they exist, because they encode the project's intended config. Fall back to direct tool invocation only when no such script exists.

### 4. Read the output and distinguish your errors

After each run, read the tool output carefully. Separate:

- **Errors you introduced or can fix** → fix them.
- **Pre-existing errors on untouched files** → *do not fix*. Just note them once ("N pre-existing warnings elsewhere, not from this change"). Scope creep here wastes time and inflates diffs.

### 5. Fix loop (re-run until clean)

Apply fixes, then re-run the same check on the same files. Loop a maximum of ~3 times. If an error won't clear (e.g. requires a config decision or a deliberate API change), stop and surface it to the user instead of looping forever or "fixing" it with a hack.

### 6. Report

Report concisely:
- What was run and on which files.
- What was fixed (auto-format, lint rule, type error).
- Anything that remains open and why (pre-existing, needs user decision).

## Hard rules

- **Never run the application** (no `npm start`, `node server.js`, `python main.py` that boots the app). This skill is static checks only.
- **Never install new dev tools** (no `npm install -D ...`, no `pip install ...`) to "make it work" — that changes the project's dependency surface. If a tool is missing, say so and stop.
- **Don't modify lint/format config** to silence a violation. Fix the code, not the rule.
- **Don't touch files you didn't edit** to "clean things up" — that's scope creep.
- Respect the project's existing config and ignore patterns; don't override `.eslintignore`, `.prettierignore`, `tsconfig.exclude`, etc.

## When the project has no tools installed

If none of prettier/eslint/tsc/etc. are present (no config files, no devDependencies entries, no scripts), do **not** run anything. Tell the user plainly: "No formatters, linters, or type-checkers detected for this project — nothing to run." Suggest (but do not install) common options if they ask.
