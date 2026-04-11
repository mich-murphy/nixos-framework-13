#!/usr/bin/env bash
# Context-efficient wrapper for coding agents.
# On success: prints a single "pass" line.
# On failure: prints the "fail" line + last N lines of output.
#
# Usage: run-silent.sh <label> <command...>
# Exit code is forwarded from the wrapped command.

set -euo pipefail

TAIL_LINES="${TAIL_LINES:-40}"
label="$1"; shift

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

if "$@" < /dev/null > "$tmpfile" 2>&1; then
  echo "PASS $label"
  exit 0
else
  rc=$?
  echo "FAIL $label (exit $rc)"
  echo "--- last ${TAIL_LINES} lines ---"
  tail -n "$TAIL_LINES" "$tmpfile"
  exit "$rc"
fi
