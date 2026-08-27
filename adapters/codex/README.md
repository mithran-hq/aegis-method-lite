# Codex adapter

Two ways to install; both carry the identical, benchmark-tested payload.

## Plugin (preferred, Codex CLI >= 0.144)

Codex consumes this repo's plugin marketplace directly — the same package as
the Claude Code plugin:

    codex plugin marketplace add mithran-hq/aegis-method-lite
    codex plugin add aegis-method@mithran

Verified on codex-cli 0.144.1: the marketplace registers as `mithran`, the
plugin installs from `plugins/aegis-method`, and the skill ships with it.
The repo carries both manifest formats; Codex reads the native
`.agents/plugins/marketplace.json` and `.codex-plugin/plugin.json`, and
older versions fall back to the legacy `.claude-plugin/` files. Plugins work
in Codex CLI and the ChatGPT desktop app — the Codex IDE extension does
not load them.

## AGENTS.md block

Append the block in `AGENTS-block.md` to your repository's `AGENTS.md`.
Codex CLI and Codex-based agents read `AGENTS.md` at session start; the
method then governs every task in the repository.

For a global install, append the same block to `~/.codex/AGENTS.md`.

Choose one mechanism, not both, or the payload appears twice in context.

Scope the method to delivery work: coding, refactoring, debugging,
shipping. Skip it for one-shot creative or writing tasks, where the
benchmark's only negative cells lived.

The payload text is verbatim from `../../PAYLOAD.md`; verify with
`../../scripts/check_payload_sync.sh`.
