# Evidence — what was measured, and what the numbers do and do not claim

The value claims in this repository rest on one controlled evaluation: the
**bench3 K10 campaign** (2026-08, 2,400 run records). This page states the
design and the honesty boundary; [`k10-results.md`](k10-results.md) carries
the distilled numbers.

## Design

- **Arms (ablation ladder):**
  - **vanilla** — no method text; absence proven by explicit configuration.
  - **guided** — the [`PAYLOAD.md`](../PAYLOAD.md) instruction block in the
    agent's context (the benchmark ran it with the plan directory named
    `.bruno/`; this repo renames it `.aegis/` — see the payload provenance).
    No enforcement of any kind.
  - **enforced** — the *identical* instruction block plus a live
    workspace-resident gate that reverts implementation mutations until the
    plan train validates. The only difference from guided is gate liveness.
- **Cohort:** 5 models × 16 tasks (5 agentic: coding + agentic workflow;
  11 single-shot: reasoning, tool use, creativity, writing) × 3 arms ×
  **k=10** repetitions.
- **Validity controls** (pre-registered, harness-enforced): fresh workspace
  per repetition; materialization proof per arm (payload digest / gate
  transcript / proven absence); pinned harness and model versions;
  contamination detection on output patches; unified token accounting;
  hidden-test fail-closed scoring (timeout = fail); paired statistics
  (McNemar on resolution, bootstrap 95% CIs on continuous deltas); any
  validity failure voids the run.

## Headline findings

1. **The payload alone produces the method's artifacts.** Valid plan trains
   (plan + children, every child with falsifiers) in **99.6%** of guided
   runs vs **0%** vanilla. The live gate adds nothing on top (98.4%). The
   method's procedural value — auditable plans, explicit assumptions,
   falsifiers, closure records — requires no enforcement infrastructure.
2. **Guidance lifts outcomes where the task is hard for the model.**
   Single-shot resolution: vanilla 369/550 → guided 392/550. The lift
   concentrates in hard reasoning cells (per-cell deltas of +0.4 to +0.7
   pass rate for the weaker models). Tasks a model already saturates stay
   saturated — the method does not change outcomes there.
3. **The cost is real:** on agentic tasks, guided runs used roughly 1.9×
   the output tokens and ~2.5× the wall time of vanilla (CIs in the results
   page). You pay in tokens and time; you receive artifacts, and lift where
   the model was struggling.
4. **Not free everywhere:** two cells moved negative under guidance
   (reported in the results table), and in the campaign's k=3 pilot the
   payload changed one model's *answer format* on a single-shot reasoning
   cell enough to fail an objective checker. Method payloads belong in
   agentic/delivery contexts, which is what this repo targets.

## Honesty boundary

Adopted verbatim from the source campaign's corrected record:

> The supported conclusion is procedural: the method can require and record
> plans, frozen commitments, evidence, and closure attempts. This does
> **not** establish that the method makes an agent reliable, correct, or
> complete.

Additional discipline for anyone quoting these numbers:

- No causal phrasing where a confidence interval includes zero.
- Negative cells are reported, not dropped.
- Aggregates only: raw run records and trajectories are not published here.

## Reproducing the tables

`k10-stats.json` is the aggregate output of the campaign's statistics
script (`k10_stats.py`, paired per-cell stats over the raw records).
[`generate_results.py`](generate_results.py) renders
[`k10-results.md`](k10-results.md) from it and computes nothing new:

```
python3 evidence/generate_results.py
```

The raw records and the statistics script are not published; the
tables here regenerate from the published aggregate, `k10-stats.json`.
The campaign's completion sign-off — a checklist over the full record
set — is held with the raw records.
