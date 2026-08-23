# Engineering preferences

- **Commits:** short, meaningful Conventional Commits — `<type>: <short description>` with `feat`, `fix`, `revert`, `chore`, `docs`. Keep commits small, focused, and atomic.
- **Naming:** names describe actual behavior — avoid `handle()`, `process()`, `doSomething()`; prefer `fetchUserProfile()`, `validatePaymentToken()`.
- **Explicit over implicit:** make contracts visible, name things clearly, define data shapes, avoid hidden behavior.
- **Simple over clever:** simple solutions over flexible ones; maintainability over cleverness; fewer dependencies.
- **No speculative features** (YAGNI) — build only what is needed now.
- **File size:** keep files under ~1000 lines; split into focused modules when approaching the limit.