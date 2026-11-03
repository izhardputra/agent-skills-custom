#!/usr/bin/env python3
"""Context budget check for this repo.

Measures what every session pays for (shared rules + descriptions of skills the
model may invoke on its own) and the size of each SKILL.md, then compares them
with config/budget.json. Exit code 1 when any limit is exceeded.

Usage: python3 scripts/check-budget.py [--json]
Tokens are estimated as characters / 4.
"""
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent


def tokens(text: str) -> int:
    return round(len(text) / 4)


def frontmatter(text: str) -> dict:
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    out, key, block = {}, None, []
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if key and (line.startswith(" ") or not line.strip()):
            block.append(line.strip())
            out[key] = " ".join(b for b in block if b)
            continue
        key, block = None, []
        if ":" in line:
            k, v = line.split(":", 1)
            v = v.strip()
            if v in (">", "|", ">-", "|-"):
                key, out[k.strip()] = k.strip(), ""
            else:
                out[k.strip()] = v.strip("\"'")
    return out


def main() -> int:
    budget = json.loads((ROOT / "config" / "budget.json").read_text())
    rules = (ROOT / "rules" / "AGENTS.md").read_text()
    skills = []
    for path in sorted((ROOT / "skills").glob("*/SKILL.md")):
        text = path.read_text()
        fm = frontmatter(text)
        auto = str(fm.get("disable-model-invocation", "false")).lower() != "true"
        desc = fm.get("description", "")
        skills.append({
            "name": path.parent.name,
            "auto": auto,
            "desc_tokens": tokens(fm.get("name", "") + desc),
            "lines": text.count("\n") + 1,
        })

    auto = [s for s in skills if s["auto"]]
    m = {
        "rules_lines": rules.count("\n") + 1,
        "rules_tokens": tokens(rules),
        "skills_total": len(skills),
        "auto_skills": len(auto),
        "auto_desc_tokens": sum(s["desc_tokens"] for s in auto),
        "max_skill_desc_tokens": max((s["desc_tokens"] for s in auto), default=0),
        "max_skill_lines": max((s["lines"] for s in skills), default=0),
    }
    m["always_loaded_tokens"] = m["rules_tokens"] + m["auto_desc_tokens"]

    limits = {
        "rules_lines": budget["rules_max_lines"],
        "rules_tokens": budget["rules_max_tokens"],
        "auto_skills": budget["auto_skills_max"],
        "auto_desc_tokens": budget["auto_desc_tokens_max"],
        "max_skill_desc_tokens": budget["skill_desc_tokens_max"],
        "max_skill_lines": budget["skill_lines_max"],
        "always_loaded_tokens": budget["always_loaded_tokens_max"],
    }
    over = {k: (m[k], v) for k, v in limits.items() if m[k] > v}
    heavy = [s["name"] for s in skills if s["lines"] > budget["skill_lines_max"]]

    if "--json" in sys.argv:
        print(json.dumps({"measured": m, "limits": limits, "over": over,
                          "skills": skills}, indent=2))
    else:
        print(f"{'metric':<24}{'value':>8}{'limit':>8}")
        for k, v in limits.items():
            flag = "  OVER" if k in over else ""
            print(f"{k:<24}{m[k]:>8}{v:>8}{flag}")
        print(f"skills: {m['skills_total']} total, {m['auto_skills']} model-invocable")
        if heavy:
            print("SKILL.md over line limit:", ", ".join(heavy))
    return 1 if over else 0


if __name__ == "__main__":
    sys.exit(main())
