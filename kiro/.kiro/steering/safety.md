# Safety — Git and irreversible operations

## Git safety

Never commit, push, or create a pull request without explicit user approval.

- **Explicit** means the user literally says "commit this", "push it", or "submit a PR".
- **Not explicit:** "go ahead", "do it", "apply it", "fix it", "sounds good", "yes".
- Showing diffs, staging, and suggesting commit messages are always OK.
- When uncertain, ask. Never assume.

## Irreversible operations

Before any operation that can cause irreversible loss of data, state, configuration, or system behavior — a migration, schema change, data manipulation, `rm`/`drop`/`delete`, or a config edit that changes system behavior — ensure a backup exists or the change is reversible.

Prefer reversible operations and additive changes over destructive ones.