# Model roster (role → T3 target)

One place to change when models change. If a target fails, check T3 `orchestrator_capabilities` and update this file only.

Billing: Claude and GPT (Pi `openai/*` and the Codex CLI, both via ChatGPT login) are subscriptions, so prefer them. Pi-GPT and Codex share one ChatGPT quota. DeepSeek is a pay-per-token API: fallback only. Gemini (Antigravity) has a tiny quota: opt-in third opinion only. GPT-6 Astra's list price is ~5× GPT-6.1 Sol, so it likely drains quota faster: use it where it pays off.

Target format: `providerInstanceId · model · options`.

| Role | Default | Escalate / fallback |
|---|---|---|
| Brain: light work, alignment, final review | `claudeAgent · claude-opus-5-5 · effort high` (xhigh at L3) | `pi · openai/gpt-6-astra` |
| Brain: heavy execution (≥3 tickets, long sessions) | `pi · openai/gpt-6-astra · thinking high` | `claudeAgent · claude-opus-5-5` if GPT quota is out |
| Daily L0–L1 | `claudeAgent · claude-opus-5-5 · effort medium` | `claudeAgent · claude-sonnet-5-5` |
| Hands: tickets | `pi · openai/gpt-6.1-sol · thinking medium` | `pi · openai/gpt-6-astra` for hard or once-failed tickets; `pi · deepseek/deepseek-flash · thinking low` only if GPT quota is out |
| Hands: mechanical edits | `pi · openai/gpt-6.1-sol · thinking low` | n/a |
| Reviewer: code (L2) | Codex CLI `codex review "<diff + spec + focus>"` (config default `gpt-6-astra`; spec in the prompt is required) | `pi · openai/gpt-6.1-sol · thinking high`, role review |
| Reviewer: adversarial (L3) | Codex CLI `codex review -c model_reasoning_effort="high" "<diff + spec + challenge>"` | `antigravity · gemini-4-argon-high` (opt-in, L3-critical only) |
| Reviewer when GPT built it | `claudeAgent · claude-opus-5-5` (`code-review`) | n/a |
| Document second reader | `pi · openai/gpt-6.1-sol · thinking high` | `claudeAgent · claude-opus-5-5` if GPT wrote it |
| Research (rare) | `pi · openai/gpt-6.1-sol · thinking medium` | `antigravity · gemini-3.8-flash-medium` |
| Weekly retro (scheduled) | project default of "AI Workflow": `claudeAgent · claude-sonnet-5-5` | n/a |
