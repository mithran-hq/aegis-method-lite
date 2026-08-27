# Claude Code adapter

Two ways to install; both carry the identical, benchmark-tested payload.

**Project-wide (always on):** copy the block from `CLAUDE-block.md` into the
project's `CLAUDE.md`. Every session then works under the method.

**Per-task (skill):** copy `skill/aegis-method/` into your project's
`.claude/skills/` directory:

    cp -r skill/aegis-method <your-project>/.claude/skills/

Then invoke `/aegis-method` (or let Claude auto-select it for non-trivial
delivery tasks).

**Plugin:** `/plugin marketplace add mithran-hq/aegis-method-lite` installs
the same skill from the repo root.

Pick one mechanism. A pasted block is always on and the skill loads per
task; running both puts the payload in context twice and pays its token
cost twice.

Scope the method to delivery work: coding, refactoring, debugging,
shipping. Skip it for one-shot creative or writing tasks, where the
benchmark's only negative cells lived. `../../examples/walkthrough.md`
shows what a finished train looks like.

The payload text is verbatim from `../../PAYLOAD.md`; verify with
`../../scripts/check_payload_sync.sh`.
