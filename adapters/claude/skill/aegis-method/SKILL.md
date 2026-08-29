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

## Order the plan train by evidence

Ordering is the discipline inside the five moves, not a sixth move. A
topologically valid train can still be product-order wrong. Optimize for
earliest trustworthy evidence of user value, then let evidence reorder the
train.

Define the MVP as the smallest coherent end-to-end journey where a real or
representative user attempts a meaningful job, the result is observable, and
Stop/Pivot/Continue is possible. Minimum is scope, not permission for poor
quality: required safety, privacy, reliability, accessibility, and
operations remain gates.

Use three nested evidence gates:

- Testable: a real or representative user attempts the core job; the riskiest
  consequential assumption is observable; a threshold and falsifier are
  explicit.
- Usable: the intended user can repeat the journey without builder rescue;
  the normal path and important failure states are handled at acceptable
  effort, clarity, and reliability for the declared context.
- Lovable: observed preference or repeat behavior crosses a declared
  threshold. Delight and trust are evidence, not a mood.

These gates are nested: Lovable cannot bypass Usable or trustworthy. Broad
and resilient work comes later when evidence justifies it.

Use the vehicle ladder as a guardrail: skateboard / Testable, scooter /
Controlled, bicycle / Usable, motorcycle / Lovable, car / Broad and
resilient. Every rung transports the user. A candidate is a coherent
vertical slice or a separately justified risk-reduction experiment; component
work lives inside a slice.

Build the feasibility DAG from verified hard dependencies only. Evidence
order, resource collisions, and preferences are planning annotations. Filter
unsafe, unauthorized, blocked, and incoherent candidates first. Value
ordering chooses only among ready slices and never violates a hard gate.

Then compare the ready slices with this exact lexicographic key, left to
right, stopping at the first difference:

~~~
cost of delay;
consequential uncertainty;
decision value;
learning value;
important risk retired;
shorter time to trustworthy evidence;
expected validated user value;
downstream unlock;
lower coordination cost;
lower irreversibility cost;
narrower slice
~~~

Use ordinal judgments, not fake decimals. This is an adaptive heuristic, not
a proof of mathematical optimality. Keep a sequential product spine. Add a
parallel lane only when it is independently useful, bounded, and has an
explicit contract and join.

For each milestone, write the user promise, full demo journey, exact
sequence/lanes, metric threshold, falsifier, explicit deferrals, and
Stop/Pivot/Continue rule. Execute only that milestone; reconcile against
landed journey evidence; then Stop, Pivot, or Continue and recompute or
reslice.

Preserve the exact .aegis JSON fields with this deterministic mapping:

- Parent goal: user promise and outcome.
- Parent scope: scope and non-goals, plus a clearly labeled execution
  contract containing ordered child IDs/product spine, parallel groups or
  lanes, explicit joins, milestone metric/baseline/threshold, deferrals, and
  Stop/Pivot/Continue rules. This contract is the single source of local
  execution order.
- Parent assumptions[]: actual assumptions only; never topology or order.
- Each child scope: one coherent slice or legitimate lane.
- Each child acceptance: slice-specific landed evidence and threshold; for a
  parallel lane, its join condition.
- Each child falsifiers: retraction checks.

Do not rely on ordered IDs alone or external tracker order. See METHOD.md and
docs/optimal-ordering.html when available, but these rules stand on their own.
