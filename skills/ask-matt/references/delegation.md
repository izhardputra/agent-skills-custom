# Briefs for hands and reviewers

Adapted from obra/superpowers (`writing-plans` task format and `subagent-driven-development` prompts, MIT, v7.0.1). A child sees only its brief: everything it needs must be in it or pointed to by path.

## Hands brief (one ticket)

```
ROLE: hands. You were delegated this task by an orchestrator. Do exactly this ticket.
Do not grill, write specs, or start subagents. Ask (report NEEDS_CONTEXT) instead of guessing.

Ticket: <id and title>   Level: <L1–L3>   Spec: <path or URL>
Work from: <directory / worktree>   Branch: <branch>

Files:     Create <path> · Modify <path:lines> · Test <path>
Interfaces:
  Consumes: <exact signatures from earlier tickets>
  Produces: <exact names/types later tickets rely on>
Constraints: <project-wide rules, things not to touch>
Steps: <failing test → run (Expected: FAIL …) → implement → run (Expected: PASS) → commit>
Done when: <observable acceptance check + the exact command>

Before reporting: run the full test suite once, read your own diff, and use
verification-before-completion (evidence before claims).
Report file: .work/<feature>/reports/<ticket>.md (what you did, test evidence RED/GREEN,
files changed, decisions you made, concerns).
Reply in ≤15 lines: Status DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT · commits ·
one-line test summary · concerns · report path.
```

A step is specified enough when there is exactly one reasonable thing to write. A plan longer than the code is a transcript, not a plan.

## Document hands brief

Same shape, with: audience, purpose, source documents (paths), required structure or template, tone (formal Indonesian unless stated), facts that must appear verbatim (numbers, dates, regulation references), and output file path in `.work/`.

## Reviewer brief

```
ROLE: reviewer. Read-only.
Diff: git diff <base>...HEAD  (or document: <path>)   Spec: <path>
Report only issues that would make this fail the spec or break in production.
For each: file:line (or quoted sentence), what fails, how to reproduce or check. Under 400 words.
Do not restate the builder's claims; do not suggest style changes the repo doesn't require.
```

Do not pass the builder's self-assessment to the reviewer; it biases toward agreement.
