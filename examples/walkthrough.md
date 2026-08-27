# Worked example: one task under the method

An agent running the payload on a small bug fix produces a `.aegis/` train
before it touches code. This is such a train, end to end.

The task: `src/paginate.py` drops the final page whenever the item count is
an exact multiple of the page size.

## The plan

`.aegis/plan.json`:

```json
{
  "id": "fix-pagination-last-page",
  "goal": "paginate() returns every item, including a final full page",
  "scope": "src/paginate.py and tests/test_paginate.py only",
  "status": "in_progress",
  "assumptions": [
    { "statement": "the bug is in the page-boundary condition, not in any caller" },
    { "statement": "no caller depends on the current last-page behavior" }
  ]
}
```

Two assumptions, both named before any code exists. If either breaks, the
plan says so instead of discovering it in review.

## The child slice

`.aegis/children/c1.json`:

```json
{
  "id": "c1",
  "scope": "fix the boundary condition in src/paginate.py and add a regression test",
  "acceptance": "pytest tests/test_paginate.py passes with a full-final-page case",
  "status": "in_progress",
  "falsifiers": [
    {
      "id": "f1",
      "description": "the change leaks outside the scoped files",
      "check": {
        "command": "git diff --name-only HEAD | grep -c -v -E '^(src/paginate\\.py|tests/test_paginate\\.py)$'",
        "expected_outcome": "prints 0"
      }
    },
    {
      "id": "f2",
      "description": "the fix miscounts a full final page",
      "check": {
        "command": "python3 -c \"from src.paginate import paginate; print(len(list(paginate(range(20), 10))))\"",
        "expected_outcome": "prints 20"
      }
    }
  ]
}
```

One falsifier guards the scope; the other guards the behavior. Both are
commitments about reality that the agent can run, and both would retract
the work if violated.

## The closure

The agent implements c1 in one commit, runs both falsifier checks, and
reconciles the acceptance criterion against what landed. The payload names
no closure format; this convention works:

`.aegis/closure.md`:

```
c1 closed 2026-08-24
acceptance: pytest tests/test_paginate.py — 6 passed
f1: 0 files outside scope
f2: paginate(range(20), 10) returned 20 items
```

Only then does it say "done".

## What to notice

- The code is the third artifact, written after the plan and the child.
- Every assumption and falsifier is checkable by someone who was never in
  the chat.
- Had f2 printed anything other than 20, c1 would drop back to
  `in_progress` and the trail would record the trigger.

[`METHOD.md`](../METHOD.md) §5 walks the same five moves at full length.
