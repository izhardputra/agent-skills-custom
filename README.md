# agent-skills-custom

Izhar's AI workflow: one set of skills and rules shared by Claude Code, Pi, and Codex, orchestrated in T3 Code. Built on Matt Pocock's skills, with a few picks from Addy Osmani, Superpowers, and pstack.

**Remember one command: `/ask-matt <task>`.** It picks the level, the brain, and the steps, then runs them one at a time. You answer "lanjut" (continue).

## The ladder

| Level | When | Flow |
|---|---|---|
| **L0** | Tiny edit, quick question, tidy-up | Just do it |
| **L1** | Small feature, moderate document revision | Brief alignment → build/draft → verify |
| **L2** | Big or fuzzy: new feature, MVP, large deliverable | Grill → spec → tickets → build (hands) → cross-family review → retro |
| **L3** | Production, money, auth, personal data, anything sent outside or irreversible | L2 + doubt-driven + security + **your approval** before commit/merge/deploy/send/sign |

Two tracks: **code** (git repos) and **documents** (KAK/TOR, letters, decks). Details: `skills/ask-matt/SKILL.md`.

## Who does what

- **Brain**: Claude Opus for alignment, light work, and final review. **GPT-6 Astra in the Codex harness** runs heavy executions in its own T3 thread, so ChatGPT quota is spent first.
- **Hands**: Pi with GPT-6.1 Sol, one T3 child per ticket, each in its own worktree.
- **Reviewer**: always a different model family from the builder. Codex reviews Claude's work; Claude reviews GPT's (Astra or Sol), per milestone and at the end.
- **DeepSeek** (paid API) and **Gemini** (tiny quota) are fallbacks only.

Exact targets: `config/models.md`. Shared rules: `rules/AGENTS.md`.

## Layout

```
skills/      26 skills (the single source; ~/.claude/skills/* link here)
rules/       AGENTS.md, read by Claude (~/.claude/CLAUDE.md), Pi, and Codex via symlinks
config/      models.md (role → model), budget.json (context limits)
upstream/    pinned pristine copies + licenses, sources.json
scripts/     install.sh, check-budget.py, upstream.sh
PATCHES.md   every change we made to upstream skills
```

## Install on a new Mac

1. Install and log in: T3 Code, Claude Code, Pi, Codex CLI (`codex login`), GitHub CLI.
2. Clone and wire:
   ```bash
   mkdir -p ~/Documents/"0-Setup & Scratch"
   gh repo clone izhardputra/agent-skills-custom ~/Documents/"0-Setup & Scratch"/agent-skills-custom
   ~/Documents/"0-Setup & Scratch"/agent-skills-custom/scripts/install.sh --with-codex-plugin
   ```
3. Paste the **bootstrap prompt** below into a T3 thread.
4. Check any time: `scripts/install.sh --check`.

### Bootstrap prompt (T3)

> Set up T3 for my workflow in `~/.claude/workflow`: (1) create a project "AI Workflow" at that folder with default model Claude Sonnet 5.5; (2) schedule the weekly retro from `docs/weekly-retro.md` for Friday 16:00 in that project, a new thread per run; (3) point the "No project" scratch root to `~/Documents/0-Setup & Scratch/T3 Scratch` if T3 allows it. Ask before each change.

Threads themselves live in T3's data (`~/.t3/userdata`) and session logs. Move them with macOS Migration Assistant, or later keep T3 on an always-on server.

## Longevity rules

- Changes land as PRs. CI runs `scripts/check-budget.py`; over budget means no merge.
- The weekly retro only proposes (max 3 per week), shows the budget, flags skills unused for 30 days, and checks upstream with `scripts/upstream.sh check`.
- Prefer a test, lint rule, or script over more text. Anything added should replace or shrink something.

## Credits

Skills by Matt Pocock (MIT), Addy Osmani (MIT), Jesse Vincent / Prime Radiant (MIT), and Lauren Tan (MIT). See `NOTICE.md` and `upstream/*/LICENSE`.
