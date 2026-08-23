# Node.js quality checks

Exact, project-respecting commands for Node.js projects. The general flow is **format → lint → type-check**, because prettier fixes whitespace that ESLint would otherwise also flag, and ESLint is faster feedback than the full type-check.

Always scope to the **files you actually changed** (see `detection.md`). Replace `<files>` below with explicit paths.

## 1. Prettier (formatting)

Available if: config file present (`.prettierrc*`, `.prettierignore`, or `prettier` key in `package.json`) **or** `prettier` in `devDependencies`, **and** ideally a script.

### Check (don't write) — safest first
```bash
npx prettier --check <files>
```
Use this to see if there's drift before auto-fixing.

### Write (fix)
```bash
npx prettier --write <files>
```

### Via npm script (preferred when it exists)
```bash
npm run format        # often runs --write across configured globs
npm run format:check  # often runs --check
```
Check the script's actual contents in `package.json` first — some projects make `format` write, others check. Run the one matching your intent.

Note: `npx prettier` will use the locally installed version automatically; no need for `./node_modules/.bin/prettier`.

## 2. ESLint (linting)

Available if: `eslint.config.*` (flat) or `.eslintrc*` (legacy) present, **or** `eslint` in `devDependencies` with a `lint` script.

### Lint specific files
```bash
npx eslint <files>
```

### Auto-fix what's safely fixable
```bash
npx eslint --fix <files>
```
ESLint's fixable rules will be applied; unfixable errors remain and are reported.

### Via npm script (preferred when it exists)
```bash
npm run lint -- <files>   # pass files through to the underlying eslint
npm run lint              # project-wide, per its own globs
```

### TypeScript-aware linting
If `@typescript-eslint` is installed, ESLint uses the TS parser automatically via the config. No special flags needed beyond what the project config already does. Don't invent `--ext .ts` flags on flat config — flat config infers extensions from the config file.

## 3. TypeScript type-checking

Available if: `tsconfig.json` (or `tsconfig.*.json`) present. This is the "see type problems without running the app" step — the closest thing to an LSP-level check from the CLI.

`tsc` is **whole-program**: you can't pass a single changed file and get only that file's errors. So this runs at project scope. That's expected. The discipline is in **how you read the output**:

```bash
npx tsc --noEmit
```
- `--noEmit` is mandatory: we're checking, not producing build artifacts.
- Read the output and focus on errors whose file paths are among **the files you changed**. Those are yours to fix.
- Pre-existing errors on untouched files: note the count once, don't chase them.

### Via npm script (preferred when it exists)
```bash
npm run typecheck    # or: type-check, tsc, check
```
Look for these script names in `package.json`. They typically run `tsc --noEmit` (or `tsc -p tsconfig.json --noEmit`) with the project's intended project references.

### Project references / composite
If `tsconfig.json` uses `references` (composite builds), prefer `tsc --build --noEmit` or the project's `typecheck` script — it respects the reference graph. Don't run bare `tsc --noEmit` against a solution-style tsconfig that only has `references` and no `files`/`include`, it will error or no-op.

## Recommended order for a changed-file loop

After editing one or more `.ts`/`.tsx`/`.js`/`.jsx` files:

1. `npx prettier --write <changed-files>` → normalize formatting.
2. `npx eslint <changed-files>` → lint. If fixable, re-run with `--fix`.
3. `npx tsc --noEmit` (or `npm run typecheck`) → type errors. Filter output to your files; fix yours.
4. If anything was fixed, re-run from step 1 (a type fix can introduce a lint/format issue). Cap the loop at ~3 rounds.

## Common pitfalls

- **Don't run `eslint .` or `tsc` on the whole repo just to check one file.** ESLint accepts file paths — use them. For `tsc` it's whole-program by nature, so the win is in scoping your *attention* to the output, not the invocation.
- **Don't add `--rulesdir`, `--ext`, or config overrides** unless the project already uses them. Match the project's setup.
- **Don't fix a type error by casting to `any` or adding `// @ts-ignore`/`// @ts-expect-error`** unless the user has already established that pattern. Prefer fixing the real type. If a genuine API/type-design issue blocks you, surface it rather than suppressing.
- **Prettier + ESLint conflict**: if both are configured, ESLint usually has `eslint-config-prettier` to disable formatting rules. Don't hand-merge them; trust the project's existing integration.
