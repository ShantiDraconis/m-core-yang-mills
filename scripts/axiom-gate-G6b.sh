#!/usr/bin/env bash
set -euo pipefail

LOG="${1:-/tmp/physical-gap-axioms.log}"
OUT="${2:-/tmp/g6b-footprint.txt}"
PATTERN="${AXIOM_GATE_PATTERN:-depends on axioms: \\[.*\\]}"
ALLOWED="${G6B_ALLOWED_AXIOMS:-}"

test -f "$LOG"
: > "$OUT"

if grep -E "$PATTERN" "$LOG" >/tmp/g6b-axiom-lines.txt; then
  sed -E 's/.*depends on axioms: \\[([^]]*)\\].*/\1/' /tmp/g6b-axiom-lines.txt \
    | tr ',' '\n' \
    | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' \
    | grep -v '^$' \
    | sort -u > "$OUT"
fi

if grep -q 'sorryAx' "$LOG"; then
  echo "G6b RED: sorryAx detected"
  exit 1
fi

if [[ -z "$ALLOWED" ]]; then
  if [[ -s "$OUT" ]]; then
    echo "G6b RED: footprint não vazio"
    cat "$OUT"
    exit 1
  fi
  echo "G6b GREEN: empty axiom footprint"
  exit 0
fi

printf '%s\n' "$ALLOWED" \
  | tr ',' '\n' \
  | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' \
  | grep -v '^$' \
  | sort -u >/tmp/g6b-allowed.txt

UNEXPECTED="$(comm -23 "$OUT" /tmp/g6b-allowed.txt || true)"
if [[ -n "$UNEXPECTED" ]]; then
  echo "G6b RED: unexpected axiom footprint"
  printf '%s\n' "$UNEXPECTED"
  exit 1
fi

echo "G6b GREEN: footprint is within explicit allow-list"
cat "$OUT"
