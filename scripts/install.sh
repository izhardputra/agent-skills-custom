#!/usr/bin/env bash
# Wire this repo into Claude Code, Pi, and Codex. Safe to re-run.
#
#   scripts/install.sh            link everything (existing files are backed up first)
#   scripts/install.sh --check    report only; exit 1 if anything is missing or over budget
#   scripts/install.sh --with-codex-plugin   also install openai/codex-plugin-cc for Claude Code
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
WF="$HOME/.claude/workflow"
CHECK=0; CODEX_PLUGIN=0
for a in "$@"; do
  case "$a" in
    --check) CHECK=1 ;;
    --with-codex-plugin) CODEX_PLUGIN=1 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done

problems=0
BACKUP="$REPO/.work/backup/$(date +%Y%m%d-%H%M%S)"

ok()   { printf '  ok    %s\n' "$1"; }
bad()  { printf '  FIX   %s\n' "$1"; problems=$((problems + 1)); }
done_(){ printf '  done  %s\n' "$1"; }

# link <target> <link path>
link() {
  local target="$1" path="$2"
  if [ -L "$path" ] && [ "$(readlink "$path")" = "$target" ]; then ok "$path"; return; fi
  if [ "$CHECK" = 1 ]; then bad "$path -> $target"; return; fi
  mkdir -p "$(dirname "$path")"
  if [ -e "$path" ] || [ -L "$path" ]; then
    mkdir -p "$BACKUP"; mv "$path" "$BACKUP/$(echo "$path" | sed "s#^$HOME/##; s#/#__#g")"
  fi
  ln -s "$target" "$path"; done_ "$path -> $target"
}

echo "Repo: $REPO"

echo "[1] ~/.claude/workflow"
link "$REPO" "$WF"

echo "[2] skills -> ~/.claude/skills"
mkdir -p "$HOME/.claude/skills"
for d in "$REPO"/skills/*/; do
  n="$(basename "$d")"; link "$WF/skills/$n" "$HOME/.claude/skills/$n"
done
for l in "$HOME"/.claude/skills/*; do
  [ -L "$l" ] || continue
  case "$(readlink "$l")" in
    "$WF"/skills/*) [ -e "$l" ] || { if [ "$CHECK" = 1 ]; then bad "stale link $l"; else rm "$l"; done_ "removed stale $l"; fi; } ;;
  esac
done
ign="$HOME/.claude/skills/.ignore"
if [ -f "$ign" ] && grep -qx 'synced/' "$ign"; then ok "$ign"
elif [ "$CHECK" = 1 ]; then bad "$ign (hides Claude-synced skills from Pi)"
else echo 'synced/' >> "$ign"; done_ "$ign"; fi

echo "[3] shared rules"
link "$WF/rules/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$WF/rules/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
link "$WF/rules/AGENTS.md" "$HOME/.codex/AGENTS.md"

echo "[4] Pi reads ~/.claude/skills"
PI_SETTINGS="$HOME/.pi/agent/settings.json"
if python3 -I - "$PI_SETTINGS" "$CHECK" <<'PY'
import json, pathlib, sys
p, check = pathlib.Path(sys.argv[1]), sys.argv[2] == "1"
d = json.loads(p.read_text()) if p.exists() else {}
if "~/.claude/skills" in d.get("skills", []):
    sys.exit(0)
if check:
    sys.exit(1)
d.setdefault("skills", []).append("~/.claude/skills")
p.parent.mkdir(parents=True, exist_ok=True)
p.write_text(json.dumps(d, indent=2) + "\n")
sys.exit(3)
PY
then ok "$PI_SETTINGS"
else rc=$?; if [ "$rc" = 3 ]; then done_ "$PI_SETTINGS"; else bad "$PI_SETTINGS (add \"~/.claude/skills\" to skills)"; fi; fi

if [ "$CODEX_PLUGIN" = 1 ] && [ "$CHECK" = 0 ]; then
  echo "[5] codex-plugin-cc"
  claude plugin marketplace add openai/codex-plugin-cc || true
  claude plugin install codex@openai-codex --scope user
fi

echo "[budget]"
if python3 -I "$REPO/scripts/check-budget.py"; then :; else bad "context budget exceeded"; fi

if [ "$problems" -gt 0 ]; then echo "$problems problem(s)."; exit 1; fi
[ -d "$BACKUP" ] && echo "Backed up replaced files to: $BACKUP"
echo "All good."
