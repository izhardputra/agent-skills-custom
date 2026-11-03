# Model roster (role → T3 target)

One place to change when models change. If a target fails, check T3 `orchestrator_capabilities` and update this file only.

Billing: Claude and GPT (Pi `openai/*`, the T3 `codex` provider, and the Codex CLI, all via ChatGPT login) are subscriptions, so prefer them. All GPT routes share one ChatGPT quota. DeepSeek is a pay-per-token API: fallback only. Gemini (Antigravity) has a tiny quota: opt-in third opinion only. GPT-6 Astra's list price is ~5× GPT-6.1 Sol, so it likely drains quota faster: use it where it pays off. On the T3 `codex` provider always set `serviceTier default`: its own default, `priority`, is faster but likely drains quota faster.

Harness: the GPT brain runs in Codex (GPT models are built for it); Pi stays the hands harness. Both read the same rules (`~/.codex/AGENTS.md`, `~/.pi/agent/AGENTS.md`) and open skills by path.

Target format: `providerInstanceId · model · options`.

| Role | Default | Escalate / fallback |
|---|---|---|
| Brain: light work, alignment, final review | `claudeAgent · claude-opus-5-5 · effort high` (xhigh at L3) | `codex · gpt-6-astra · reasoningEffort high · serviceTier default` |
| Brain: heavy execution (≥3 tickets, long sessions) | `codex · gpt-6-astra · reasoningEffort high · serviceTier default` | `pi · openai/gpt-6-astra · thinking high` if the codex provider is unavailable; `claudeAgent · claude-opus-5-5` if GPT quota is out |
| Daily L0–L1 | `claudeAgent · claude-opus-5-5 · effort medium` | `claudeAgent · claude-sonnet-5-5` |
| Hands: tickets | `pi · openai/gpt-6.1-sol · thinking medium` | `pi · openai/gpt-6-astra` for hard or once-failed tickets; `pi · deepseek/deepseek-flash · thinking low` only if GPT quota is out |
| Hands: mechanical edits | `pi · openai/gpt-6.1-sol · thinking low` | n/a |
| Reviewer: code Claude built | Codex CLI `codex review "<diff + spec + focus>"` (config default `gpt-6-astra`; spec in the prompt is required) | `pi · openai/gpt-6.1-sol · thinking high`, role review |
| Reviewer: code GPT built (Astra or Sol, any harness) | `claudeAgent · claude-opus-5-5 · effort high` (`code-review`), at least once per milestone and at the end | n/a. A per-ticket Codex CLI review is allowed as an extra check; it is the same family, so it never replaces Claude's |
| Reviewer: adversarial (L3) | the other family: Codex CLI `codex review -c model_reasoning_effort="high" "<diff + spec + challenge>"` if Claude built it; `claudeAgent · claude-opus-5-5 · effort xhigh` if GPT built it | `antigravity · gemini-4-argon-high` (opt-in, L3-critical only) |
| Document second reader | `pi · openai/gpt-6.1-sol · thinking high` | `claudeAgent · claude-opus-5-5` if GPT wrote it |
| Research (rare) | `pi · openai/gpt-6.1-sol · thinking medium` | `antigravity · gemini-3.8-flash-medium` |
| Weekly retro (scheduled) | project default of "AI Workflow": `claudeAgent · claude-sonnet-5-5` | n/a |
