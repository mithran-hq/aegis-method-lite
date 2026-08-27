# Aegis Method — Lite

My agent's plans used to be vibes. "Should work." "Looks done." I bet yours
are as well.

The Aegis Method is the fix: a small, hard discipline for working with LLM
coding agents. This repo is the whole install — one instruction block you
paste into your agent's context. There is no binary to install and nothing
ties you to a platform. If your agent can read a system prompt, it can run
the method.

## The claim

An LLM is a compiler that takes English and emits software. It is also
non-deterministic: same input, different output, every run. You will not fix
that with a bigger model. You fix it with the discipline around the model.

The Aegis Method is composed of five moves, in order, working in tandem to
create determinism — not inside the model, but around its output:

1. **Evidence before architecture.** Look at what is, before deciding what
   should be.
2. **Strategy before plan.** Name your assumptions before you write tasks. A
   plan without a strategy is precise nonsense.
3. **Issues as memory.** Work that exists only in chat does not exist.
4. **Falsification before confidence.** Every slice of work carries a check
   that would prove it wrong. Not a test — a commitment about reality.
5. **Closure against reality.** "Done" means reconciled against what
   actually landed. Anything else is a lie.

The agent authors this as a small plan train in its workspace, then earns
the right to say "done". Read `METHOD.md` for the full method,
or go straight to `PAYLOAD.md` and paste it.

## Cheap model, frontier behavior

We measured this the hard way: 2,400 runs, 5 models, 16 tasks, 10
repetitions per cell, hidden-test scoring, paired statistics. Same tasks
with and without the method in context. Nothing else changed.

The result I keep coming back to: on the benchmark's hardest reasoning task,
deepseek-v4-pro went from **30% to 100%** pass rate with the method in
context. That is the same 100% the frontier arms scored — from a model
priced, as of August 2026, at roughly a tenth of the strongest one. A
second small model went from 20% to 90% on the same task, and a third
from 50% to 90% on another reasoning task.

The pattern is consistent: the method moves outcomes exactly where the task
is hard for the model. Frontier models already at 100% stayed at 100%.
The weaker the model relative to the task, the bigger the lift.

And the discipline itself costs almost nothing to get: with the payload in
context, agents produced a valid plan — assumptions named, falsifiers
attached — in **99.6%** of runs. Without it: 0%.

Full tables, negative cells included, in `evidence/`.

## What it costs, honestly

The method is not free, and we say so with numbers: roughly 1.9× the output
tokens and up to 2.5× the wall time on agentic tasks, with no improvement
where a model already saturates the task. Scope it to delivery work —
coding, refactoring, debugging, shipping. The benchmark's only negative
cells were single-shot tasks, and in one pilot the payload shifted a
model's answer format enough to fail an objective checker. For a one-shot
story or summary, leave the payload out.

And the boundary: these runs show the method reliably produces auditable
plans, falsifiers, and closure evidence, and lifts hard-task outcomes. They
do not show it makes an agent reliable, correct, or complete. Nothing does.
That is the point of falsifiers.

## Install

Plugin (this repo doubles as the `mithran` marketplace):

Claude Code:

```
/plugin marketplace add mithran-hq/aegis-method-lite
/plugin install aegis-method@mithran
```

Codex CLI (0.144 or later):

```
codex plugin marketplace add mithran-hq/aegis-method-lite
codex plugin add aegis-method@mithran
```

Or skip plugins entirely and paste the block from
`PAYLOAD.md` into your `CLAUDE.md`, `AGENTS.md`, or system
prompt. Adapters with exact steps per harness are in
`adapters/`.

Pick one mechanism. The plugin and a pasted block both put the payload in
context, and running both pays its token cost twice.

The next non-trivial task starts differently: the agent writes
`.aegis/plan.json` and its child slices before it touches code
(`examples/walkthrough.md` shows a finished train). If it skips the plan,
invoke the skill explicitly (`/aegis-method:aegis-method`) or ask for the
five moves by name.

## Repository map

| Path | Contents |
| --- | --- |
| `METHOD.md` | The method in full: five moves, evidence bar, plan contract |
| `PAYLOAD.md` | The drop-in instruction block (the benchmark-tested text) |
| `adapters/` | Claude Code, Codex, and generic harness adapters |
| `plugins/` | The plugin both harnesses install from this repo |
| `evidence/` | The benchmark results and how to reproduce the tables |
| `examples/walkthrough.md` | One task end to end under the method: plan, falsifiers, closure |
| `LICENSE` | MIT |

## Status and provenance

Distilled from the full Aegis Method (`mithran-hq/aegis-method`, spec
v0.1.6) and the bench3 K10 evaluation campaign. The full method — the
specification, the engine, the enforcement layer — launches soon. This
repo stays the guided edition: prose, guidance, no enforcement.

## Contributing

No pull requests, no issues. Method semantics land upstream first and
arrive here by distillation, so a PR here would fork text maintained
somewhere else, and a forked payload is an unmeasured payload.
`CONTRIBUTING.md` says why at length. The license is MIT: fork it, paste
it, adapt it.
