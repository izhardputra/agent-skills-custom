# Changes to upstream skills

Pristine copies live in `upstream/<pack>/`. `scripts/upstream.sh diff` shows the exact diff. When upstream moves (`scripts/upstream.sh check`), copy the new version into `upstream/`, then re-apply the items below.

## mattpocock/skills @ 4ae2317 (v1.3.2)

| Skill | Change | Why |
|---|---|---|
| `ask-matt` | Rewritten as the router: levels, document track, brain allocation, T3 delegation (`references/t3.md`), briefs (`references/delegation.md`), cross-family review, approval gates. Matt's map kept, trimmed to installed skills. Upstream `PHASE-BOUNDARIES.md` and `agents/openai.yaml` unchanged. | One entry point; T3 and Pi integration |
| `grill-me`, `grill-with-docs` | Appended: state the level and the next step when the interview ends. | Hands off to the ladder |
| `handoff` | Save to `.work/handoff/` instead of the OS temp dir. | Working-files rule (no /tmp) |
| `implement` | L3: security + doubt pass, then ask before committing. | L3 gate |
| `implement-spec` | Step 2 notes go to `.work/<feature>/notes/`. Step 4: in T3, implementers are `delegate_task` children (worktree, Hands target). Step 8: L3 approval stop. | T3 hands; working-files rule; L3 gate |
| `code-review` | L3: third Security sub-agent, reported separately. | L3 security review |

Not installed: triage, wayfinder, improve-codebase-architecture, pr, teach, to-questionnaire, wait-what (unused). `.scratch/` local tracker left as upstream (sanctioned in `rules/AGENTS.md`).

## addyosmani/agent-skills @ 301b02b (v0.6.15)

`doubt-driven-development`, `security-and-hardening`, `shipping-and-launch`: the shared checklists they link (`../../references/*.md`) are bundled into each skill's `references/` and the links rewritten. No other changes. Note: `doubt-driven-development` mentions Addy's `/review`; here that role is `code-review` plus the Codex review.

## obra/superpowers @ 2ce8aa1 (v7.0.1)

`verification-before-completion`, `receiving-code-review`: unchanged. The task format and implementer/reviewer prompts were condensed into `ask-matt/references/delegation.md` (sources kept in `upstream/obra-superpowers/delegation-sources/`).

## cursor/plugins pstack @ ae5650f (0.15.36)

`sharpen`: unchanged.
