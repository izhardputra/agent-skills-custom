#!/usr/bin/env bash
# scripts/upstream.sh diff    show our changes against the pinned upstream copies
# scripts/upstream.sh check   list packs whose upstream moved past the pinned commit (network, read-only)
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$REPO"
case "${1:-}" in
  diff)
    for pack in upstream/*/; do
      for d in "$pack"*/; do
        n="$(basename "$d")"; [ -d "skills/$n" ] || continue
        diff -ru "$d" "skills/$n" || true
      done
    done ;;
  check)
    python3 -I - <<'PY'
import json, subprocess
for name, s in json.load(open("upstream/sources.json")).items():
    out = subprocess.run(["git", "ls-remote", s["repo"], "refs/heads/" + s["ref"]], capture_output=True, text=True).stdout.split()
    head = out[0] if out else "?"
    state = "up to date" if head == s["commit"] else f"NEW upstream {head[:7]} (pinned {s['commit'][:7]}, {s['date']})"
    print(f"{name:<26} {state}")
PY
    ;;
  *) echo "usage: $0 diff|check" >&2; exit 2 ;;
esac
