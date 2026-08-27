# The Aegis Method payload

This is the drop-in instruction block. Paste everything between the markers
into your agent's context — system prompt, `CLAUDE.md`, `AGENTS.md`, or
equivalent. Nothing else is required.

The text between the markers is the benchmark-tested payload with exactly
one mechanical change: the plan directory is named `.aegis/` here, where the
benchmarked text named it `.bruno/` (see provenance below). Do not edit it
casually: any further change makes your deployment a different, unmeasured
payload.

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

---

## What the agent produces

An agent running under this payload authors a `.aegis/` directory in its
workspace **before** touching implementation code:

```
.aegis/
  plan.json            one plan: goal, scope, status, assumption ledger
  children/
    c1.json            one file per child slice, each with >=1 falsifier
    c2.json
```

then implements one commit per child, runs the falsifier checks, and records
closure before claiming done. In benchmark runs, models produced a valid
train in 99.6% of guided runs with no enforcement present. A filled-in
train for a small real task lives in
[`examples/walkthrough.md`](examples/walkthrough.md).

## Notes on wording

Two sentences reference a validating "harness" ("the harness will refuse
work that skips a move"; "The harness validates this IR before
implementation work is accepted"). In guided use there is no live gate —
these sentences state the method's refusal modes as commitments the agent
holds itself. They are kept because they are part of the measured text: the
benchmark's guided arm ran this exact wording with **no** gate, and this is
the wording the results validate. If you later add enforcement (the full
Aegis Method engine), the same sentences become literally true.

## Provenance

- Source: bench3 K10 campaign payload (`method_payload.md`, P1), SHA-256
  `5dc6a290ae50d9a81d52807f841f65b6baf536eae976db3421578ae195d578b2` —
  the `materialization.payload_digest` recorded on every guided and
  enforced K10 run record.
- The block between the BEGIN/END markers is the instruction text of that
  payload. Deviations from the tested artifact: (1) the plan-directory name
  `.bruno` is renamed `.aegis` (6 occurrences, renamed 2026-08-23;
  semantically neutral — same IR shape, same fields); (2) the tested file's
  two-line header (title and digest note) is replaced by this document's
  framing. All other text is byte-identical.
- Method semantics derive from `mithran-hq/aegis-method` SPEC v0.1.6; see
  [`METHOD.md`](METHOD.md) for the full guided method.
