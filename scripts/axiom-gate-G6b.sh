#!/usr/bin/env bash
set -euo pipefail

LOG="${1:-/tmp/physical-gap-axioms.log}"
OUT="${2:-/tmp/g6b-footprint.txt}"
ALLOWED="${G6B_ALLOWED_AXIOMS:-}"
EXPECTED="${EXPECTED_THEOREM_COUNT:-3}"

test -f "$LOG"
: > "$OUT"

DEP_LINES="$(grep -E "depends on axioms: \[[^]]*\]" "$LOG" || true)"
NONE_LINES="$(grep -E "does not depend on any axioms" "$LOG" || true)"
DEP_COUNT="$(printf '%s\n' "$DEP_LINES" | grep -c . || true)"
NONE_COUNT="$(printf '%s\n' "$NONE_LINES" | grep -c . || true)"
PARSED_COUNT=$((DEP_COUNT + NONE_COUNT))

echo "EXPECTED_THEOREM_COUNT=$EXPECTED"
echo "PARSED_THEOREM_COUNT=$PARSED_COUNT"
echo "DEPENDS_LINES=$DEP_COUNT"
echo "NO_AXIOM_LINES=$NONE_COUNT"

if [ "$PARSED_COUNT" -ne "$EXPECTED" ]; then
  echo "G6b RED: parser coverage mismatch"
  exit 1
fi

if grep -q 'sorryAx' "$LOG"; then
  echo "G6b RED: sorryAx detected"
  exit 1
fi

if [ "$DEP_COUNT" -gt 0 ]; then
  printf '%s\n' "$DEP_LINES" \
    | sed -E 's/.*depends on axioms: \[([^]]*)\].*/\1/' \
    | tr ',' '\n' \
    | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' \
    | grep -v '^$' \
    | sort -u > "$OUT"
fi

if [ -z "$ALLOWED" ]; then
  if [ -s "$OUT" ]; then
    echo "G6b RED: footprint non-empty under empty allow-list"
    cat "$OUT"
    exit 1
  fi
  echo "G6b GREEN: all $EXPECTED theorem footprints empty"
  exit 0
fi

printf '%s\n' "$ALLOWED" \
  | tr ',' '\n' \
  | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' \
  | grep -v '^$' \
  | sort -u >/tmp/g6b-allowed.txt

UNEXPECTED="$(comm -23 "$OUT" /tmp/g6b-allowed.txt || true)"
if [ -n "$UNEXPECTED" ]; then
  echo "G6b RED: unexpected axiom footprint"
  printf '%s\n' "$UNEXPECTED"
  exit 1
fi

echo "G6b GREEN: footprint within explicit allow-list"
cat "$OUT"
