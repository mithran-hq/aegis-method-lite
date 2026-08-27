# Aegis Method — plugin (Claude Code and Codex)

Ships one skill carrying the benchmark-tested guided-method payload (digest
pinned in `.claude-plugin/plugin.json` metadata; provenance in the repo's
`PAYLOAD.md`). The same package installs into both harnesses and carries
both manifests: `.codex-plugin/plugin.json` for Codex natively,
`.claude-plugin/plugin.json` for Claude Code and for older Codex versions
that read the legacy format.

## Install — Claude Code

```
/plugin marketplace add mithran-hq/aegis-method-lite
/plugin install aegis-method@mithran
```

Claude then auto-selects the skill for non-trivial delivery tasks, or invoke
it explicitly with `/aegis-method:aegis-method`.

## Install — Codex CLI (>= 0.144)

```
codex plugin marketplace add mithran-hq/aegis-method-lite
codex plugin add aegis-method@mithran
```

Verified on codex-cli 0.144.1 (marketplace registers as `mithran`; plugin
installs with the skill).

## Versioning

The plugin version tracks the payload identity: any change to the payload
text is a new `payload_digest` and a version bump in both manifests and the
marketplace entry together. The skill body must stay byte-identical to the
block in the repo's `PAYLOAD.md`. `scripts/check_payload_sync.sh` enforces
both invariants.
