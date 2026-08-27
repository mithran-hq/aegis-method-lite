#!/usr/bin/env bash
# Verify every adapter embeds the payload block from PAYLOAD.md verbatim.
set -euo pipefail
cd "$(dirname "$0")/.."
ref=$(sed -n '/<!-- AEGIS-METHOD-PAYLOAD-BEGIN -->/,/<!-- AEGIS-METHOD-PAYLOAD-END -->/p' PAYLOAD.md)
[ -n "$ref" ] || { echo "FAIL: no payload block in PAYLOAD.md"; exit 1; }
fail=0
for f in adapters/claude/skill/aegis-method/SKILL.md \
         plugins/aegis-method/skills/aegis-method/SKILL.md \
         adapters/claude/CLAUDE-block.md \
         adapters/codex/AGENTS-block.md \
         adapters/generic/system-prompt.md; do
  got=$(sed -n '/<!-- AEGIS-METHOD-PAYLOAD-BEGIN -->/,/<!-- AEGIS-METHOD-PAYLOAD-END -->/p' "$f")
  if [ "$got" = "$ref" ]; then echo "OK   $f"; else echo "FAIL $f"; fail=1; fi
done

# Both plugin manifests and the Claude marketplace entry carry a version;
# they must move together (payload change => digest change => version bump).
python3 - <<'PY' || fail=1
import json, sys
def load(p):
    with open(p) as f:
        return json.load(f)
vers = {
    "plugins/aegis-method/.claude-plugin/plugin.json":
        load("plugins/aegis-method/.claude-plugin/plugin.json")["version"],
    "plugins/aegis-method/.codex-plugin/plugin.json":
        load("plugins/aegis-method/.codex-plugin/plugin.json")["version"],
    ".claude-plugin/marketplace.json":
        load(".claude-plugin/marketplace.json")["plugins"][0]["version"],
}
if len(set(vers.values())) != 1:
    for k, v in vers.items():
        print("FAIL", k, v)
    sys.exit(1)
print("OK   manifest versions:", set(vers.values()).pop())
PY
exit $fail
