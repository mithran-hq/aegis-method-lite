---
name: aegis-method
description: Work under the Aegis Method - five mandatory moves (evidence, strategy, issues-as-memory, falsification, closure) with a .aegis/ plan train authored before any implementation. Use for any non-trivial coding, refactoring, debugging, or delivery task.
---

<!-- AEGIS-METHOD-PAYLOAD-BEGIN -->
You are operating under the Aegis Method. It is a sequence of five mandatory moves. Each move has a
refusal mode: the harness will refuse work that skips a move. Comply in order.

Move 1 — Evidence Before Architecture. Before any architectural decision, record current behavior,
recent changes, and known constraints as evidence in the plan. Fact before opinion.

Move 2 — Strategy Before Plan. Commit major decisions (approach, ownership, sequence) to the plan with
an explicit ASSUMPTION LEDGER: for this to work, what must be true? for it to fail, what must be true?
Prefer fewer assumptions and decisions that are easy to undo. A plan without strategy is precise nonsense.

Move 3 — Issues As Memory. Structure the work as one parent plan plus CHILD SLICES. Every child has:
- id (stable identifier), scope (what it changes), acceptance (what proves it done), owner (you),
- status (pending | in_progress | done | rejected).
Work that exists only in chat does not exist. The plan is the memory.

Move 4 — Falsification Before Confidence. Every child carries at least one FALSIFIER: a check that would
prove the child WRONG if violated — falsifier: { id, description, check: { command, expected_outcome } }.
A child without a falsifier is not buildable. Do not confuse the falsifier with the test: the falsifier
is the commitment about reality that retracts the work when reality violates it. A plan is weak
("this should work"), strong ("this should work unless A1..An fail"), or am ("experiment E will tell us
whether A1..An hold"). Only am plans pass.

Move 5 — Closure Against Reality. Before declaring done, reconcile acceptance against the landed state:
run the falsifier checks, link evidence, and record the closure. "Done" without reconciliation is a lie.

Delivery contract: author a committed .aegis/ train. The harness validates this IR
before implementation work is accepted. Use EXACTLY these fields:

.aegis/plan.json:
  { "id": "<stable id>", "goal": "<what should be true>", "scope": "<what changes>",
    "status": "in_progress", "assumptions": [ { "statement": "<what must be true / fail>" } ] }

.aegis/children/<child-id>.json (one per child):
  { "id": "<stable id>", "scope": "<what this child changes>", "acceptance": "<what proves it done>",
    "status": "pending | in_progress | done | rejected",
    "falsifiers": [ { "id": "<stable id>", "description": "<what would prove it wrong>",
                      "check": { "command": "<shell command>", "expected_outcome": "<exit code / text>" } } ] }

One commit per child, and closure records.
<!-- AEGIS-METHOD-PAYLOAD-END -->
