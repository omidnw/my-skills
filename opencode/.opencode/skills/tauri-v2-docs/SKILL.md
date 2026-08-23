---
name: tauri-v2-docs
description: Fetch and reference Tauri v2 documentation. Use when the user works with
  Tauri 2.x and needs API details, config keys, permissions, plugin usage, or CLI flags —
  e.g. mentions of Tauri, tauri.conf.json, @tauri-apps/api, invoke, #[tauri::command],
  tauri plugins, or Tauri Rust/JS APIs.
---

# Tauri v2 Docs — Reference

## Purpose
Resolve the exact Tauri v2 documentation page for a task and pull the needed
API/config/plugin details into the answer — like Cursor's @Docs for Tauri v2. Tauri v2
docs have an official `llms.txt` index, so page resolution is reliable, not guessed.

## When to use
- Any question or implementation touching Tauri 2.x: Rust side (`tauri`, `tauri-build`),
  JS side (`@tauri-apps/api`, `@tauri-apps/cli`), config (`tauri.conf.json`),
  permissions/capabilities (ACL), plugins (`tauri-plugin-*`), or the Tauri CLI.
- Verifying a v2 API signature, config key, or permission identifier before writing code.

## Preconditions
- You have web access (`WebFetch`/`WebSearch`).
- The project is a Tauri **v2** project (check `package.json` / `Cargo.toml` if unsure —
  `tauri = "2"`, `@tauri-apps/api@^2`). This skill covers v2 only.

## Workflow
1. **Identify the area** the user is working in: setup/config, Rust core API, JS API,
   plugins, permissions/ACL, CLI/build, or distribution/mobile.
2. **Resolve the exact page** using the Doc map below. If the map doesn't cover it, fetch
   the right `llms` file (`llms.txt` index, `_llms-txt/guides.txt`, or
   `_llms-txt/reference.txt`) and pick the precise URL — never guess deep links.
3. **Fetch the target page** with `WebFetch`, with a focused extraction prompt
   ("Extract the signature, example code, and config keys for X") — do not dump the
   whole page into context.
4. For **Rust API** questions, fetch the relevant module on
   `https://docs.rs/tauri/latest/tauri/` (e.g. `app`, `manager`, `window`, `webview`,
   `fs`, `path`, `process`, `command`, `tray`, `menu`, `event`, `image`, `ipc`).
5. **Cross-check** the result against v2 idioms (see Rules), then answer with code and
   cite the source URL.

## Doc map (verified entry points)

| Need | Entry point |
|---|---|
| Index of all v2 docs (llms.txt) | `https://v2.tauri.app/llms.txt` |
| Full docs text (LLM-readable) | `https://v2.tauri.app/llms-full.txt` |
| Abridged docs text | `https://v2.tauri.app/llms-small.txt` |
| Guides set (start, concept, security, develop, distribute, learn, plugin) | `https://v2.tauri.app/_llms-txt/guides.txt` |
| Reference set (JS API, config schema, CLI, ACL/permissions) | `https://v2.tauri.app/_llms-txt/reference.txt` |
| Rust API (crates) | `https://docs.rs/tauri/latest/tauri/` |
| Getting started / guides hub | `https://v2.tauri.app/start/` |
| CLI reference (web) | `https://v2.tauri.app/reference/cli/` |

## Rules
- **v2 only.** `tauri.app` and `v1.tauri.app` are Tauri v1 docs — never use them for v2.
- **Version alignment.** A v2 project must use only v2 artifacts: `tauri` crate ^2,
  `@tauri-apps/api`/`@tauri-apps/cli` ^2, `tauri-plugin-*` v2.x, and the v2
  `tauri.conf.json` schema. Never mix v1 code with v2.
- Resolve URLs via the `llms` index instead of guessing paths.
- Rust API always via `docs.rs/.../latest/...` — never an older version tag. Plugin
  crates have their own docs (e.g. `docs.rs/tauri-plugin-shell/latest/`).
- Plugin questions → the plugin's own guide page under `v2.tauri.app` (e.g.
  `/plugin/shell/`) or its docs.rs crate; plugins are separate crates with separate APIs.
- When embedding fetched content into an answer, cite the source URL.
- If a page 404s or looks stale, fall back to `llms-full.txt` or a
  `WebSearch` limited to `site:v2.tauri.app`.

## Common mistakes
- Copying v1 examples: `tauri::api::*` modules (`fs`, `path`, `dialog`) are **gone** in
  v2 — replaced by `tauri::fs`, `tauri::path`, and `tauri-plugin-dialog`.
- Using `app.get_window(...)` — v2 uses `app.get_webview_window(...)` / `get_webview_windows()`.
- Calling `invoke` from `@tauri-apps/api/tauri` — v2 imports it from `@tauri-apps/api/core`.
- Using the v1 `tauri.conf.json` shape (no `$schema`, no `app.windows`, no
  `capabilities/` folder) — v2 requires the new schema and a permissions file per
  capability.
- Pulling `llms-full.txt` wholesale into context — it is huge; fetch targeted pages or
  the section files only.

## Validation
- Run a sample query end-to-end, e.g. "Show a file dialog in Tauri v2" must resolve to
  `tauri-plugin-dialog` / `@tauri-apps/plugin-dialog` (v2), not v1 `tauri::api::dialog`.
- Confirm `https://v2.tauri.app/llms.txt` is reachable before relying on it.
- Verify any code you produce compiles against the fetched signatures (cite the page).
