# The Aegis Method — Lite

> A discipline for engineering with LLM agents. This is the guided edition:
> the method as instructions an agent (or a human) can follow on any
> harness, with no engine, no gate, and nothing to install.
>
> Distilled from the Aegis Method specification v0.1.6 (+ Mithran
> evidence-boundary merge). The full specification, including the
> enforcement layer, lives in `mithran-hq/aegis-method`.

---

## 1. The premise: the compiler changed

Treat the LLM as a compiler whose source language is English and whose
target is running software. A task description is a **program**. The model
compiles it into candidate artifacts; the agent loop executes them; reality
returns observations.

Two facts drive everything else:

> **A1 — Non-determinism.** The LLM compiler is non-deterministic by
> construction. The same program may produce different artifacts on
> different runs. Treat that as permanent.
>
> **C1 — The discipline corollary.** The guarantees therefore come from the
> *discipline around* the compiler, not from the compiler.

This method is that discipline.

## 2. A well-formed program

A task description qualifies as a program only when it has:

1. a **goal** — what should be true after the work lands,
2. a **scope** — what must and must not change,
3. a **target** — the system the work compiles against.

A description missing one of these is a wish. Rewrite it before working on
it. English is ambiguous on purpose; the error is not ambiguity, it is
letting unresolved ambiguity survive into the plan. Surface every ambiguity
as a named **assumption** (see Move 2).

Judge programs by content, not by author. An LLM-authored program needs the
same evidence and falsification bar as a human-authored one.

## 3. The type system: evidence

**A claim about the work type-checks if and only if it is evidenced.**

Evidence kinds, each carrying provenance (who produced it, when, against
what version of reality):

```
Evidence ::=
    Test(spec, run)              -- a test spec linked to a recorded run
  | Log(query, range, hit)       -- a log query in a time range with hits
  | Repro(commands, output)      -- a deterministic command sequence
  | Inspection(artifact, obs)    -- direct inspection of a landed artifact
  | Reference(authority, cite)   -- a citation against a tiered authority
  | Reconciliation(claim, state) -- a claim resolved against landed state
```

Weak claims and their minimum acceptable upgrades:

| Weak | Floor |
|---|---|
| "It works on my machine" | linked test run |
| "I checked it" | repro command |
| "Looks fixed" | root cause + regression check |
| "Demo passed" | gate evidence |
| "Merged" | landed state reconciled |

### 3.1 Confabulation is a type error

> **A2.** Any claim not backed by evidence is a **confabulation**. Surface
> it and refuse to advance the work until it is resolved.

Confabulation is the LLM's most distinctive failure mode. This type system
exists mostly to catch it.

### 3.2 The Root Rule

Whoever authors the program — human or agent — operates under:

> **Assume you are confabulating.**
> **Check facts.**
> **Then check the facts that would prove you wrong.**

Skip the third clause and you are type-blind.

### 3.3 Claim-property congruence

Evidence type-checks a claim only when it observes **the property the claim
depends on**. Names, labels, config keys, issue titles, and intended
backends help you *locate* evidence; they are never evidence themselves.

If the claim is "this ran in an isolated VM", a node *named* `vm-*` proves
nothing; observe the actual runtime backend. If the claim is "the endpoint
returns 200", the deploy log proves nothing; call the endpoint. For every
material claim, name the proof obligation: the claim, the property it
depends on, the observation that shows the property held, and the falsifier
that would show it did not.

### 3.4 Serving state is truth

> **A6.** Claims about deployed systems resolve against the system's
> *serving state* at the time of resolution — never against bookkeeping,
> stale review state, the last log line, or the agent's conclusion.

## 4. The plan IR: work must live outside the chat

Chats decay, prompts drift, agents forget, humans misremember. The method
counters all four by making the plan a durable, structured artifact in the
workspace — the **plan train**: one parent plan plus child slices.

| | Parent plan | Child slice |
|---|---|---|
| Role | coordination artifact | delivery unit |
| Holds | goal, scope, assumption ledger, sequence | one scope, one acceptance, one commit |
| Splits into | children | nothing — children do not nest |
| Done when | every child reconciled, assumptions re-validated | acceptance met against landed state |

The canonical local shape (validated by benchmark, exact fields in
[`PAYLOAD.md`](PAYLOAD.md)) is a `.aegis/` directory:

```
.aegis/plan.json           -- id, goal, scope, status, assumptions[]
.aegis/children/<id>.json  -- id, scope, acceptance, status, falsifiers[]
```

Where the team uses an issue tracker, mirror the same structure there:
one parent issue, one child issue per slice, and never implement directly
from a parent. Work that exists only in chat does not exist.

Record state transitions as you make them (append, never rewrite): the
trail is what lets a later agent — or you, after a context loss — resume
without resurrecting already-falsified ideas as fresh uncertainty.

### 4.1 Ordering the train: earliest trustworthy value

Ordering is the discipline **inside** the five moves, not a sixth move. A
train can be topologically valid and still be product-order wrong: every
dependency is satisfied while the user journey, the learning, and the
decision evidence arrive too late. Order for the earliest trustworthy
evidence of user value, then let that evidence change the train.

An **MVP** is the smallest coherent end-to-end journey where a real or
representative user attempts a meaningful job, the system produces an
observable result, and the team can decide **Stop, Pivot, or Continue**.
Minimum is scope, not quality. Required safety, privacy, reliability,
accessibility, and operational controls remain gates when they are part of
the promise.

Use three nested evidence gates:

- **Testable:** a real or representative user attempts the core job; the
  riskiest consequential assumption is observable; a threshold and falsifier
  are explicit.
- **Usable:** the intended user can repeat the journey without builder
  rescue; the normal path and important failure states are handled at
  acceptable effort, clarity, and reliability for the declared context.
- **Lovable:** observed preference or repeat behavior crosses a declared
  threshold. Delight and trust are evidence, not a mood.

The gates are nested. Lovable cannot bypass usable or trustworthy; broad and
resilient work comes later when the evidence justifies it.

Use the vehicle ladder as a guardrail against component-first thinking:

```
skateboard → scooter → bicycle → motorcycle → car
 Testable      Controlled   Usable     Lovable     Broad / resilient
```

Every rung transports the user. The first rung is a narrow complete journey;
later rungs make that same journey more controlled, usable, lovable, and
then broad and resilient. Build components only as part of a rung or journey
that transports the user. Component-only milestones are not user value. A fuller visual and
worked examples live in [`docs/optimal-ordering.html`](docs/optimal-ordering.html).

The candidate unit is a **coherent vertical slice** or a separately
justified risk-reduction experiment. Component work lives inside a slice;
it does not outrank a slice merely because it is a large or difficult
component. Infrastructure is work in the train when it is a verified hard
dependency or material risk reducer for the promised journey. Proof
machinery makes a claim trustworthy; it does not become product value by
being difficult.

Keep two graphs distinct. The feasibility DAG contains only **verified hard
dependencies**: edges that make a later slice unsafe or impossible without
an earlier one. Evidence-order relationships, resource collisions, and
preferences are planning annotations, not feasibility edges. Challenge
accidental relationships and split cycles with an interface, stub, or
experiment. Delivery ordering chooses only among ready nodes and never
overrides a hard safety, authority, or dependency gate.

After gates and coherent-slice filtering, compare ready slices with this
single qualitative key, left to right:

```
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
```

Use ordinal judgments and stop at the first difference. Do not invent
decimals or pretend the result is a proof of mathematical optimality. This
is an adaptive heuristic: its inputs and order are recomputed when reality
changes.

Keep a sequential **product spine** for the user promise. Add parallel lanes
only when the work is independently useful, bounded, and has a clear
contract and explicit join or gate. Otherwise parallelism is serial work
hidden in columns.

The practical loop is:

1. Observe current reality.
2. Define the user, job, outcome, and non-goals.
3. Rewrite the backlog as coherent slices or experiments.
4. Classify relationships and build the DAG from verified hard edges.
5. Filter unsafe, unauthorized, blocked, unready, or incoherent candidates.
6. Rank the ready slices with the key above.
7. Define a milestone contract: user promise, full journey, exact sequence
   and lanes, threshold, falsifier, explicit deferrals, and Stop/Pivot/Continue.
8. Execute only the current milestone.
9. Reconcile the result against landed user-journey evidence.
10. Stop, Pivot, or Continue; then recompute, reslice, or end.

Encode ordering without changing the exact `.aegis` JSON schema. Use this
deterministic mapping:

- Parent `goal`: the user promise and outcome.
- Parent `scope`: scope and non-goals, plus a clearly labeled **execution
  contract** containing the ordered child IDs/product spine, parallel
  groups or lanes, explicit joins, milestone metric/baseline/threshold,
  deferrals, and Stop/Pivot/Continue rules. This labeled contract is the
  single source of local execution order.
- Parent `assumptions[]`: actual assumptions only. Do not put topology or
  order here.
- Each child `scope`: its one coherent slice or legitimate lane.
- Each child `acceptance`: slice-specific landed evidence and threshold; for
  a parallel lane, include its join condition.
- Each child `falsifiers`: retraction checks.

Do not rely on ordered IDs alone or on external tracker order. The contract
is memory only when the next agent can inspect, reconcile, and revise it.

## 5. The Five Moves

Five mandatory passes, in order. Each has a refusal mode — the condition
under which you stop and go back rather than continue.

### Move 1 — Evidence Before Architecture

Before any architectural decision, capture what **is**: current behavior,
recent changes, owner notes, known incidents — as evidence, into the plan.

*Refusal:* architectural decisions made before this pass are unsound; roll
them back. Fact before opinion.

### Move 2 — Strategy Before Plan

Commit the major decisions — approach, ownership, sequence — with an
explicit **assumption ledger**, using two lenses:

- **Assumption lens:** for this to work, what must be true? For it to fail,
  what must be true?
- **Decision lens:** prefer fewer assumptions, and decisions that are easy
  to undo. Occam first, reversibility second.

*Refusal:* a task list generated before strategy is **precise nonsense**.
Do not decompose into children until the strategy holds.

### Move 3 — Issues As Memory

Turn the strategy into the plan train: parent plan plus child slices, each
child with scope, acceptance, owner, and status.

*Refusal:* work that exists only in chat does not exist. Do not advance
from chat-state.

### Move 4 — Falsification Before Confidence

Give every child at least one **falsifier**: an explicit check that would
prove the child *wrong* if violated, with a concrete command and expected
outcome.

A falsifier is not a test. Tests live inside the build; a falsifier is a
**commitment about reality** that retracts the work when reality violates
it. A passing test does not retire a falsifier; a passing falsifier does.
You need both.

Plan strengths:

```
"this should work"                                → Weak
"this should work unless A_1..A_n fail"           → Strong
"experiment E will tell us whether A_1..A_n hold" → am
```

A weak plan asserts, a strong plan bounds its risk, and an am plan names
the experiment that settles it.

*Refusal:* a child without a falsifier is **not buildable**. Only am-grade
plans pass.

### Move 5 — Closure Against Reality

Before declaring done: run the falsifier checks, reconcile each acceptance
criterion against the **landed state**, link the evidence, and record the
closure.

*Refusal:* "done" without reconciliation is a lie. Neither the agent nor
the human declares closure by fiat — reconciliation does.

## 6. The debugger: falsification

For every claim `P` in the plan, ask: **what would prove `P` wrong?** A
claim that cannot answer is undebuggable, and a plan built on it is
rejected by Move 4.

Falsifiers act like breakpoints on reality:

- "If the new query exceeds 1.5× the old latency, retract."
- "If the migration touches more than the listed tables, retract."
- "If the audit log shows access outside the scoped principals, retract."

When a falsifier fires, the affected child drops back from *done* to
*in_progress* — or to *rejected* when the falsifier kills the approach —
and the trail records the trigger.

Point falsifiers at properties, not names: "the node is named
`firecracker-*`" is not a falsifier for isolation; "the observed runtime
backend is not Firecracker" is.

The method applies this to itself. It would be wrong — and should retire —
if teams consistently ship sound, reconciled, evidence-bearing work without
it; if LLMs become deterministic enough to retire the discipline; or if a
simpler discipline strictly dominates it. A method without falsifiers is a
religion.

## 7. The linker: adversarial review

At review time, resolve every claim against the artifact it describes:

| Claim | Landed state | Result |
|---|---|---|
| "endpoint returns 200" | returns 500 | link error |
| "no permission regression" | audit log shows new access | link error |
| "RCA explains the new behavior" | RCA pre-dates the change | link error |
| "ran in isolation" | observed backend is local | link error |

Three stages, all required: **static** (types, lints, schema, contract
tests), **dynamic** (integration runs, smoke checks), **reality**
(production observation against acceptance).

> **A5.** Review is adversarial: its job is to *try to break* the build.
> Produce a falsification attempt for every claim; merge only if the
> attempt fails. A review that rubber-stamps is broken.

The author of a change is disqualified as its adversary. Small changes may
take a peer adversary; load-bearing changes need the owner of the affected
surface, and benefit from an outsider who attacks the framing itself.

## 8. Bounded execution

A child slice is a bounded execution. Working guided (no enforcement), the
agent holds these bounds itself:

- **One scope** — do not write outside the child's scope.
- **One claim** — before implementing, mark the child in progress with who
  and where; if someone else already claimed it, stop and coordinate.
- **One clean checkout** — implement from a fresh, up-to-date checkout or
  worktree scoped to the child, never a shared mutable one.
- **One commit** — one child, one commit, unless the child is split first.
- **Termination** — stop when a falsifier fires or the budget is exhausted,
  and say so, rather than thrash.

## 9. What the method guarantees — and what it does not

Guarantees, when followed:

- **Soundness** — claims that pass the evidence bar are not confabulations.
- **Reproducibility** — the work can be replayed from its plan and trail,
  up to the compiler's non-determinism.
- **Locality** — a child's failure stays inside the child until the parent
  reconciles.
- **Falsifiability** — every plan names the experiment that could disprove it.

Explicit non-guarantees:

- The LLM will not emit the same artifact twice (A1).
- A sound plan is not necessarily the *right* plan.
- Falsifiers do not cover all failures (mitigate with outsider review).
- Evidence goes stale (re-link before close) and authorities can collapse
  (re-tier on revalidation).
- The method narrows the failure envelope; it cannot eliminate it.

Measured, honestly: prose guidance alone reliably produces the method's
artifacts and helps most where the task is hard for the model; it does not
make an agent reliable, correct, or complete. See [`evidence/`](evidence/).

## 10. Anti-patterns: programs that do not compile

| Anti-pattern | Why it fails |
|---|---|
| "Use an agent" | no goal, no scope, no target |
| "Make it work" | no acceptance |
| "Demo passed" | link-time short-circuit |
| "Merged" | linker bypassed reality |
| "It works on my machine" | evidence floor not met |
| "I checked it" | unverifiable evidence |
| "The config says isolated" | label-as-proof; intent is not serving state |
| "We'll test it later" | falsifier missing |
| "The agent says it's done" | serving state not consulted |
| "Trust the model" | discipline corollary inverted |

These are type errors, not style objections. A build containing any of
them is still a draft.

---

## Provenance

Distilled 2026-08-23 from `mithran-hq/aegis-method` `SPEC.md` (v0.1.6 +
Mithran evidence-boundary merge, 2026-06-18). Sections kept: compilation
model (§1), source language (§2), evidence type system (§3), IR (§4), Five
Moves (§5), falsification (§6), adversarial review (§7), bounded execution
(from §8.2), soundness (§10), anti-patterns (§11). Sections excluded from
this edition: engine and enforcement (§8.5–8.10), work-item naming
registry (§8.12), distance metric (§12).
