# Weekly retro (scheduled prompt)

You are running the weekly retro for the workflow in `~/.claude/workflow`. Read-only: propose, never apply.

1. **Budget.** Run `python3 -I scripts/check-budget.py` and `scripts/install.sh --check`. Report the table and any problem.
2. **Upstream.** Run `scripts/upstream.sh check`. For any pack with a new commit, summarise what changed in the skills we vendor (see `upstream/sources.json`, `PATCHES.md`) and whether our patches still apply.
3. **The week's threads.** With T3 tools, search this week's threads (not subagent threads). Read only final messages and "Decisions & assumptions" sections, not full transcripts. Note: which levels and skills were used, where the flow caused friction, repeated agent mistakes, and threads that look finished.
4. **Proposals (max 3).** Each one: the problem (with thread links), the change, where it goes, and its budget effect. Prefer a test, lint rule, script, or T3 project script over more text; anything that adds text must remove or shrink something else. Flag skills with no use in 30 days as removal candidates.
5. **Housekeeping.** List threads that can be settled or archived. Do not archive them yourself.

Reply in Indonesian, under 400 words, ending with the budget line: `Anggaran konteks: <always_loaded_tokens>/<limit> token`.
If the user approves a proposal, implement it on a branch in this repo and open a PR; CI must pass before merge.
