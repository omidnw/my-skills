#!/usr/bin/env bash
# sync-skills.sh — copies the canonical skills/ folder into every supported
# environment's skill directory. Run after adding, editing, or removing a skill:
#
#   ./scripts/sync-skills.sh
#
# Canonical source of truth: ./skills/<name>/SKILL.md (+ references/, scripts/).
# Skills in ZCODE_ONLY depend on ZCode-specific commands and tools (see below)
# and are shipped ONLY to the zcode/ environment, never to the others.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/skills"

# ZCode-only skills: they reference ZCode client features that other
# environments do not have — /compact and /clear (context-compact) and the
# ReadSessionContext tool + #sess_... IDs (session-handoff). Shipping them
# elsewhere would add noise that can never trigger usefully.
ZCODE_ONLY=(context-compact session-handoff)

# Skills excluded from this repo entirely (published with a separate project).
EXCLUDED=(animated-infographic)

# environment folder -> native skills subfolder (zcode gets everything)
ENVS=(
  "claude/.claude/skills"
  "cursor/.cursor/skills"
  "kiro/.kiro/skills"
  "zcode/.zcode/skills"
  "opencode/.opencode/skills"
  "chatgpt/.agents/skills"
)

ZCODE_TARGET="zcode/.zcode/skills"

if [[ ! -d "$SRC" ]]; then
  echo "error: $SRC not found — nothing to sync" >&2
  exit 1
fi

for target in "${ENVS[@]}"; do
  rm -rf "$ROOT/$target"
  mkdir -p "$ROOT/$target"
  for skill in "$SRC"/*/; do
    skill="${skill%/}"   # drop trailing slash so cp copies the folder, not its contents
    name="$(basename "$skill")"
    if [[ " ${EXCLUDED[*]} " == *" $name "* ]]; then
      echo "skipped (excluded) -> $name ($target)"
      continue
    fi
    if [[ "$target" != "$ZCODE_TARGET" && " ${ZCODE_ONLY[*]} " == *" $name "* ]]; then
      echo "skipped ZCode-only -> $name ($target)"
      continue
    fi
    cp -R "$skill" "$ROOT/$target/"
  done
  echo "synced -> $target"
done

echo "done."