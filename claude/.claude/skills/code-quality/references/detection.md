# Detection: language and installed tools

This is the canonical reference for figuring out what a project uses, so the skill never runs a tool that isn't actually installed.

## Principle

**Read the project's own manifest; never assume.** A `.ts` file does not mean TypeScript is installed. A `package.json` does not mean ESLint is set up. Detect, then act.

## Node.js

Present if `package.json` exists at the project root (or in a workspace package).

To find which tools are installed and how they're meant to be run, check three things and **merge the signals**:

1. **`package.json` → `scripts`** — the project's intended entry points. Common names: `lint`, `eslint`, `format`, `format:check`, `typecheck`, `type-check`, `tsc`, `check`. These are preferred because they bundle the project's flags and file globs.
2. **`package.json` → `devDependencies`** — confirms the binary is actually installed: `prettier`, `eslint`, `typescript`, `@typescript-eslint/*`, shared configs like `eslint-config-*`.
3. **Config files in the root** — prove the tool is actively configured:
   - Prettier: `.prettierrc`, `.prettierrc.json`, `.prettierrc.yml`, `.prettierrc.js`, `.prettierignore`, or a `prettier` key in `package.json`.
   - ESLint: `eslint.config.js` / `eslint.config.mjs` (flat config, ESLint 9+) or `.eslintrc` / `.eslintrc.json` / `.eslintrc.yml` / `.eslintrc.js` (legacy). `.eslintignore`.
   - TypeScript: `tsconfig.json`, `tsconfig.*.json`.

Rule of thumb: a tool counts as "available" if **either** a config file exists **or** it's in `devDependencies` with a runnable script. If it's in `devDependencies` but there's no config and no script, it's probably not actively used — mention it but don't force-run it.

## Python

Present if any of: `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `requirements-dev.txt`, `Pipfile`, `poetry.lock`.

Detect:
- **`pyproject.toml`** is the modern hub. Look under `[tool.black]`, `[tool.ruff]`, `[tool.mypy]`, `[tool.isort]`, `[tool.flake8]`. Also `[project.optional-dependencies]` / `[tool.poetry.group.dev.dependencies]` for the dev tool list.
- `setup.cfg` has `[tool:flake8]`, `[mypy]`, `[isort]` sections.
- `requirements*.txt` — grep for `black`, `ruff`, `mypy`, `isort`, `flake8`.

## Go / Rust / others

- Go: `go.mod`. `gofmt` and `go vet` are part of the toolchain, so no separate install check needed.
- Rust: `Cargo.toml`. `cargo fmt` and `cargo clippy` ship with the toolchain.
- For any other language: apply the same logic — find the manifest, find the dev-tool section, find the config.

## Monorepos / workspaces

If the project is a workspace (npm `workspaces` field, Lerna, Turborepo, pnpm workspaces), each package may have its own config and its own `package.json`. Detect at the package you're editing, and prefer that package's scripts/config. For type-checking across the workspace, use the root `tsconfig` / root `typecheck` script.

## Detecting "the files I changed"

To scope checks correctly you need to know which files you edited in this session. Use what's available in the current environment:

- If `git` is available and the repo is tracked: `git diff --name-only` (unstaged) and `git diff --staged --name-only`, plus `git status --porcelain`. Filter to source files for the detected language.
- If not tracked by git: keep an in-session mental list of the files you created or edited, and pass those paths explicitly.

Only pass files that actually exist on disk and belong to the detected language — don't hand a `.md` path to ESLint, don't hand a `.py` to `prettier`.
