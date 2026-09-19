#!/usr/bin/env bash
set -euo pipefail

# Global fast-CI regression firewall. This is infrastructure-only.
# Normal certification paths must remain targeted and cache-preserving.
# Full clean/global reproduction belongs in explicitly named manual/periodic workflows.

ROOT="${1:-.}"
violations="$(mktemp)"
trap 'rm -f "$violations"' EXIT

mapfile -t files < <(find "$ROOT" -type f \( -path '*/.github/workflows/*.yml' -o -path '*/.github/workflows/*.yaml' -o -name '*.sh' \) \
  ! -path '*/.git/*' | sort)

for f in "${files[@]}"; do
  # Exempt only explicitly separated full-reproduction workflows.
  case "$f" in
    *full-reproduction*.yml|*full-reproduction*.yaml|*full_reproduction*.yml|*full_reproduction*.yaml)
      continue ;;
  esac

  if grep -nE '(^|[;&|[:space:]])lake[[:space:]]+clean([;&|[:space:]]|$)' "$f" >/tmp/no-umbrella-hit 2>/dev/null; then
    while IFS= read -r hit; do printf '%s:%s\n' "$f" "$hit" >> "$violations"; done </tmp/no-umbrella-hit
  fi
  if grep -nE '(^|[;&|[:space:]])lake[[:space:]]+build[[:space:]]+MCore([;&|[:space:]]|$)' "$f" >/tmp/no-umbrella-hit 2>/dev/null; then
    while IFS= read -r hit; do printf '%s:%s\n' "$f" "$hit" >> "$violations"; done </tmp/no-umbrella-hit
  fi
  # Bare 'lake build' is an umbrella build. A target must follow it.
  if grep -nE '^[[:space:]]*(timeout[[:space:]]+[^[:space:]]+[[:space:]]+)?lake[[:space:]]+build[[:space:]]*([#].*)?$' "$f" >/tmp/no-umbrella-hit 2>/dev/null; then
    while IFS= read -r hit; do printf '%s:%s\n' "$f" "$hit" >> "$violations"; done </tmp/no-umbrella-hit
  fi
done

if test -s "$violations"; then
  echo "NO_UMBRELLA=FAIL"
  cat "$violations"
  exit 1
fi

echo "NO_UMBRELLA=PASS"
echo "NO_LAKE_CLEAN_NORMAL_CI=PASS"
echo "TARGETED_BUILDS_ONLY=PASS"
echo "REGRESSION_FIREWALL=PASS"
