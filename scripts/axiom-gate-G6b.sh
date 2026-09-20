#!/usr/bin/env bash
set -euo pipefail

LOG="${1:-/tmp/physical-gap-axioms.log}"
OUT="${2:-/tmp/g6b-footprint.txt}"
ALLOWED="${G6B_ALLOWED_AXIOMS:-}"
EXPECTED="${EXPECTED_THEOREM_COUNT:-3}"

test -f "$LOG"
: > "$OUT"

python3 - "$LOG" "$OUT" "$EXPECTED" "$ALLOWED" <<'PY'
import re
import sys
from pathlib import Path

log_path = Path(sys.argv[1])
out_path = Path(sys.argv[2])
expected = int(sys.argv[3])
allowed_raw = sys.argv[4]

text = log_path.read_text(encoding="utf-8", errors="replace")

# Lean may pretty-print an axiom list across several lines. Parse complete
# #print-axioms records instead of assuming the closing ']' is on line one.
pattern = re.compile(
    r"(?m)^'[^'\n]+'\s+"
    r"(?:(does not depend on any axioms)|"
    r"depends on axioms:\s*\[([\s\S]*?)\])"
)
records = list(pattern.finditer(text))

dep_records = []
none_count = 0
axioms = set()

for m in records:
    if m.group(1) is not None:
        none_count += 1
        continue
    raw = m.group(2) or ""
    dep_records.append(raw)
    for item in raw.replace("\n", " ").split(","):
        ax = item.strip()
        if ax:
            axioms.add(ax)

parsed_count = len(records)
dep_count = len(dep_records)

print(f"EXPECTED_THEOREM_COUNT={expected}")
print(f"PARSED_THEOREM_COUNT={parsed_count}")
print(f"DEPENDS_LINES={dep_count}")
print(f"NO_AXIOM_LINES={none_count}")

if parsed_count != expected:
    print("G6b RED: parser coverage mismatch")
    raise SystemExit(1)

if "sorryAx" in text:
    print("G6b RED: sorryAx detected")
    raise SystemExit(1)

out_path.write_text(
    "".join(f"{ax}\n" for ax in sorted(axioms)),
    encoding="utf-8",
)

allowed = {x.strip() for x in allowed_raw.split(",") if x.strip()}

if not allowed:
    if axioms:
        print("G6b RED: footprint non-empty under empty allow-list")
        for ax in sorted(axioms):
            print(ax)
        raise SystemExit(1)
    print(f"G6b GREEN: all {expected} theorem footprints empty")
    raise SystemExit(0)

unexpected = sorted(axioms - allowed)
if unexpected:
    print("G6b RED: unexpected axiom footprint")
    for ax in unexpected:
        print(ax)
    raise SystemExit(1)

print("G6b GREEN: footprint within explicit allow-list")
for ax in sorted(axioms):
    print(ax)
PY
