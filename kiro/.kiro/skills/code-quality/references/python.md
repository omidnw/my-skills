# Python quality checks

Exact, project-respecting commands for Python projects. Detection signals are in `detection.md`. Flow: **format → lint → type-check**, same as Node.

Scope to **changed files** by passing explicit paths. Replace `<files>` below with the actual `.py` paths you edited.

## 1. Formatter

### Black (the de facto standard)
Available if `[tool.black]` in `pyproject.toml`, or `black` in requirements/dev-deps.

```bash
# check only
black --check --diff <files>
# fix
black <files>
```
Black is opinionated; it rarely has flags to tweak beyond line length (configured in `pyproject.toml`, don't override on the CLI).

### Ruff format (modern, fast, drop-in for Black)
Available if `[tool.ruff]` in `pyproject.toml` and ruff is installed. Ruff also lints.

```bash
ruff format --check <files>     # check
ruff format <files>             # fix
ruff check <files>              # lint
ruff check --fix <files>        # lint + autofix
```
If a project has Ruff, prefer it for **both** formatting and linting — it's one tool and reads one config.

### isort (import sorting)
Often paired with Black. Available if `[tool.isort]` in `pyproject.toml` or `isort` in deps.

```bash
isort --check-only --diff <files>
isort <files>
```
Note: Black and isort need a compatible profile (`isort` `profile = "black"` in config). Don't add flags to force compatibility on the CLI; trust the config.

## 2. Linter

### Ruff (preferred modern)
Covers flake8/pyflakes + many more, and is configured in `pyproject.toml` `[tool.ruff]`.

```bash
ruff check <files>          # report
ruff check --fix <files>    # autofix safe rules
```

### Flake8 (legacy)
Available if `[tool:flake8]` in `setup.cfg`/`tox.ini`, `.flake8`, or `flake8` in deps.

```bash
flake8 <files>
```
Flake8 has no `--fix`; violations are reported only, you fix by hand.

## 3. Type-checker

### mypy
Available if `[tool.mypy]` in `pyproject.toml`, `[mypy]` in `setup.cfg`, or `mypy` in deps.

```bash
mypy <files>
```
- mypy can type-check individual files (unlike `tsc`), so pass the changed files directly.
- But mypy often needs to follow imports across the package. If it reports import errors for your own modules, run it at the package root instead: `mypy .` or `mypy <package_dir>`, then filter the output to your changed files.

### Pyright / basedpyright
Available if `pyrightconfig.json` exists or the project references it.

```bash
pyright <files>
```

## Recommended order for a changed-file loop

1. Format: `ruff format <files>` (or `black <files>`) then `isort <files>` if present.
2. Lint: `ruff check --fix <files>` (or `flake8 <files>` — hand-fix reported ones).
3. Type-check: `mypy <files>`.
4. If anything changed, re-run from step 1. Cap at ~3 rounds.

## Common pitfalls

- **Don't run `black .` / `ruff check .` on the whole repo** for a one-file change — pass the changed paths.
- **Virtual environments**: if the project uses `venv`/`poetry`/`uv`, the tools must run from that environment. Prefer the project's runner: `poetry run black <files>`, `uv run black <files>`, or `python -m black <files>` after activating the env. Don't `pip install` tools globally to "make it work".
- **Don't silence mypy with `# type: ignore`** or `Any` casts unless the project already uses that pattern. Fix the real type; surface hard blockers to the user.
- **Don't add `# noqa`** to silence flake8/ruff unless the project already does so for that line and the suppression is clearly intentional.
