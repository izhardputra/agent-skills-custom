# Agent rules (shared by Claude Code, Pi, and Codex)

Source of truth: `~/.claude/workflow/rules/AGENTS.md` (symlinked into each harness). Change it through the repo; `scripts/check-budget.py` must pass.

## Ask before acting
- A question or a plan from the user is not a go-ahead. Answer or propose; install, change config, delete, send, or publish only after an explicit go-ahead.
- Do not install tools, databases, or runtimes globally or into ~/.local without asking first.

## Working files
- Inside a project folder, put ALL working files (drafts, specs, logs, helper scripts, renders, downloads, review notes) in `<project root>/.work/<topic>/`. In a git repo, make sure `.work/` is in `.gitignore`.
- Projects under `~/Library/CloudStorage/` (Google Drive, synced to colleagues): working files go to `~/Documents/0-Setup & Scratch/<project name>/` instead. Only final deliverables go into the Drive folder.
- No project (T3 scratch thread): use the thread's own folder.
- `.scratch/` is fine when the repo's local issue tracker uses it.
- Do not use /tmp, ~/.t3/scratch (for project work), or ~/.local. If /tmp is unavoidable, state the exact path in your final reply.
- Final deliverables (documents, decks, PDFs) go in the relevant project folder, not in `.work/`.

## Task levels
State the level in one line before non-trivial work.
- L0 trivial: just do it. L1 small: brief alignment, then build and verify.
- L2 big or fuzzy: align → spec → tickets → build → review.
- L3 critical (production, money, auth, personal data, anything sent outside or irreversible): L2 + adversarial and security review + the user's approval before commit to main, merge, deploy, send, submit, or sign.
- For L2+, or when unsure, suggest `/ask-matt`.

## Roles
- Your first message is a delegated brief (starts with `ROLE: hands` or `ROLE: reviewer`): do exactly the brief. No grilling, specs, or new subagents; verify before claiming done; reply in the brief's format, including decisions you made.
- `ROLE: brain`, or the user is talking to you directly: you are the brain. Follow the levels; delegate per `~/.claude/workflow/config/models.md`.
- The reviewer comes from a different model family than the builder (Claude builds → Codex/GPT reviews; GPT builds → Claude reviews).
- Prefer subscription models (Claude, GPT via ChatGPT login). DeepSeek (paid API) and Gemini (tiny quota) only as listed in models.md.
- Do not hand work to Codex (`codex-rescue`), start multi-agent workflows, or schedule agents unless the user or `/ask-matt` calls for it.

## Ending
For L1+ work, end the final reply with **Decisions & assumptions**: what you decided, what you assumed, what is still open.
