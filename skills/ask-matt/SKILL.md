---
name: ask-matt
description: Ask which level, brain, and flow fits a task, then run it step by step. A router over the skills in this setup.
disable-model-invocation: true
---

# Ask Matt (Izhar's fork)

Forked from Matt Pocock's `ask-matt` (mattpocock/skills, MIT, commit 4ae2317). Matt's map of flows is kept below; the additions are task levels, a document track, brain allocation, T3 delegation, cross-family review, and approval gates. Changes are listed in `~/.claude/workflow/PATCHES.md`.

Before stating what a skill does or recommending a step be skipped, read that skill's SKILL.md (`~/.claude/skills/<name>/SKILL.md`): the summaries here are for orientation only.

## 1. Classify (always first, in ≤5 lines)

- **Level**: L0 trivial (just do it) · L1 small (brief alignment, then build/verify) · L2 big or fuzzy (align → spec → tickets → build → review) · L3 critical (production, money, auth, personal data, anything sent outside or irreversible: L2 + adversarial and security review + approval gates).
- **Track**: code (a git repo) or document (KAK/TOR, letters, decks, reports).
- **Weight**: light (≤2 tickets, one sitting) or heavy (≥3 tickets, long session, many back-and-forths).
- **Brain**: see §2.
- **Approval points**: list exactly where you will stop for the user.

Then show the plan (§3) and ask "Mulai?". Do nothing else until the user agrees.

## 2. Allocate the brain (decide now, while Claude still has quota)

Read `~/.claude/workflow/config/models.md` for targets.

- L0–L1, light L2, and official documents → **Claude** stays the brain.
- Heavy L2–L3 → Claude runs alignment (grill, spec, tickets) in this thread, then hands **execution** to a **GPT-6 Astra brain** in its own T3 thread (`references/t3.md` §Brain handoff). Claude returns at the end for review and the decision summary.
- The user can override at any time: "hemat Claude" → hand more to Astra (including alignment); "pakai Claude" → keep everything here.
- You cannot see remaining quota; decide by task weight, not by guesses about quota.

## 3. Route

| Level · track | Sequence |
|---|---|
| L0 | Do it. |
| L1 · code | `grill-me` (2–3 questions max) → `tdd` → `verification-before-completion` |
| L1 · doc | `sharpen` → draft in `.work/` → `verification-before-completion` (check facts, numbers, names, dates) |
| L2 · code | `grill-with-docs` → `to-spec` → `to-tickets` → build (`implement` per ticket, or `implement-spec`; tickets go to **hands** via T3) → `code-review` + cross-family review (§5) → `receiving-code-review` → `retro` |
| L2 · doc | `grill-me` → outline in `.work/` (user approves) → draft section by section → second reader (§5) → `receiving-code-review` → final file into the project folder → `retro` |
| L3 | the L2 sequence + `doubt-driven-development` on key decisions + `security-and-hardening` (code) + `shipping-and-launch` (deploys) + a **stop for approval** before commit-to-main, merge, deploy, send, submit, or sign |

Bugs that resist a first look: `diagnosing-bugs`, then `retro`. A design question that needs a runnable answer: `handoff` → `prototype` → `handoff` back.

## 4. Run the flow

- **One step at a time.** After each step, say what is next in one line and wait for "lanjut". Then read that skill's SKILL.md and follow it. The user never has to type the next command; they may still type it themselves.
- Skills marked `disable-model-invocation` are still followed this way: read the file, don't call the Skill tool.
- Keep grilling → spec → tickets in one unbroken context. Each ticket then gets a fresh context: a T3 child (`references/t3.md`) is exactly that.
- If T3 tools are not available (plain Claude Code, a colleague's machine), do the same steps yourself in this session.

## 5. Review pairing (builder ≠ reviewer family)

- Claude or Pi-GPT built the code → **Codex** reviews. Always pass the spec in the prompt (without it Codex treats odd behaviour as intended); a prompt cannot be combined with `--base`/`--uncommitted`, so name the diff in the prompt: `codex review "Review the changes in git diff <base>...HEAD. Spec: <path + the key requirements>. Report only issues that would make this fail the spec, with file:line."` At L3 add an adversarial pass with `-c model_reasoning_effort="high"` and "Challenge the design: hidden assumptions, failure modes, rollback, security."
- GPT-6 Astra was the brain or built it → **Claude** reviews (`code-review`, run here).
- Documents → second reader on Pi · GPT-6.1 Sol (or Claude if GPT wrote it).
- A finding counts only if you can point to the line and reproduce or quote it. Process findings with `receiving-code-review`.
- Gemini is an opt-in third opinion for L3-critical work only (tiny quota).

## 6. Close

End with **Decisions & assumptions** (what was decided, what was assumed, what is open). For L2–L3, offer `retro`.

---

## Matt's map (kept from upstream, trimmed to the installed skills)

### The main flow: idea → ship

1. **`/grill-with-docs`** sharpens the idea by interview and leaves a paper trail (`GLOSSARY.md`, ADRs). No working directory? Use **`/grill-me`**; both run the **`/grilling`** primitive.
2. **Can every question be settled in conversation?** If one needs a runnable answer (state, business logic, a UI you have to see), detour: **`/handoff`** out → **`/prototype`** → **`/handoff`** back.
3. **Multi-session build?**
   - **Yes** → **`/to-spec`**, then **`/to-tickets`** (tracer-bullet tickets with **blocking edges**). Work them with **`/implement`** per ticket (fresh context each), or **`/implement-spec`** for the whole graph on one **integration branch**.
   - **No** → **`/implement`** right here.

   Code is built by driving **`/tdd`** (one red-green slice at a time) and closes with **`/code-review`** (Standards + Spec).
4. **`/retro`** closes the loop: it suggests changes to the agent's **environment**, not the code. Mechanical mistakes become deterministic checks; judgement calls become standards. Proposals go through the budget in §Longevity.

**Context hygiene.** Keep steps 1–3 in one context window. Stay inside the **smart zone** (~150k tokens; ~60% of the window as a rule of thumb); near it, `/compact` at the nearest phase boundary. See [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) for Continue / `/clear` / `/handoff` / subagent / `/compact`.

### On-ramp

- **Something's broken** → **`/diagnosing-bugs`**: no theorising until there is one command that goes red on this bug; fix with a regression test; then `/retro`.

### Vocabulary underneath

- **`/domain-modeling`**: sharpen domain language, resolve overloaded terms, record hard-to-reverse decisions as ADRs.
- **`/codebase-design`**: deep-module vocabulary (module, interface, depth, seam, adapter) for shaping a module.

### Standalone

- **`/research`**: background agent reads primary sources and leaves a cited Markdown file.
- **`/wizard`**: an interactive script for steps only a human can take (credentials, dashboards, secrets).
- **`/writing-for-agents`**: how to write skills and AGENTS.md.
- **`/sharpen`** (from pstack): make a task deeper, not bigger, before rewriting the prompt.

### Precondition

**`/setup-matt-pocock-skills`**: run once per repo to configure the issue tracker, labels, and doc layout.

## Longevity

Changes to skills or rules go through the repo (`~/.claude/workflow`) as a PR, and `scripts/check-budget.py` must pass. Prefer a test, lint rule, or script over more text; anything added should replace or shrink something else.
