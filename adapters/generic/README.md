# Generic adapter

For any harness that lets you set a system prompt or persistent instruction
block: inject the block in `system-prompt.md` verbatim.

## Self-check prompt

Guided use has no live validator. To make the agent verify its own train
before implementation, add this single line after the payload:

    Before your first implementation change, verify: .aegis/plan.json parses,
    has a non-empty assumptions array, and every .aegis/children/*.json has
    at least one falsifier with a runnable check.command and an
    expected_outcome. If any check fails, fix the train before proceeding.

## Minimal expectations of the harness

- The agent can create files in its working directory (for `.aegis/`).
- The agent can run shell commands (for falsifier checks). If it cannot,
  falsifier checks degrade to review-time commitments — still authored,
  executed by a human.

Scope the payload to delivery work: coding, refactoring, debugging,
shipping. Skip it for one-shot creative or writing tasks, where the
benchmark's only negative cells lived. `../../examples/walkthrough.md`
shows what a finished train looks like.

The payload text is verbatim from `../../PAYLOAD.md`; verify with
`../../scripts/check_payload_sync.sh`.
