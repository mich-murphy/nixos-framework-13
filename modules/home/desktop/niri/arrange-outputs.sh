#!/usr/bin/env bash
# Arrange external monitors above the laptop panel.
# - Externals stack side-by-side at y=0, sorted by name.
# - eDP-1 sits below, centered horizontally under the externals.
# Idempotent: only issues niri msg calls when a position needs changing.
set -euo pipefail

INTERNAL="eDP-1"

outputs=$(niri msg --json outputs)

# Bail out if the laptop panel isn't active (e.g. lid closed).
if ! jq -e --arg n "$INTERNAL" 'has($n) and (.[$n].logical != null)' >/dev/null <<<"$outputs"; then
    exit 0
fi

internal_w=$(jq -r --arg n "$INTERNAL" '.[$n].logical.width' <<<"$outputs")

mapfile -t externals < <(jq -r --arg n "$INTERNAL" '
    to_entries
    | map(select(.key != $n and .value.logical != null))
    | sort_by(.key)
    | .[].key
' <<<"$outputs")

set_position() {
    local name="$1" want_x="$2" want_y="$3"
    local cur_x cur_y
    cur_x=$(jq -r --arg n "$name" '.[$n].logical.x' <<<"$outputs")
    cur_y=$(jq -r --arg n "$name" '.[$n].logical.y' <<<"$outputs")
    if [[ "$cur_x" != "$want_x" || "$cur_y" != "$want_y" ]]; then
        niri msg output "$name" position x="$want_x" y="$want_y"
    fi
}

if [[ ${#externals[@]} -eq 0 ]]; then
    set_position "$INTERNAL" 0 0
    exit 0
fi

x=0
total_w=0
max_h=0
for ext in "${externals[@]}"; do
    set_position "$ext" "$x" 0
    w=$(jq -r --arg n "$ext" '.[$n].logical.width' <<<"$outputs")
    h=$(jq -r --arg n "$ext" '.[$n].logical.height' <<<"$outputs")
    x=$((x + w))
    total_w=$((total_w + w))
    if (( h > max_h )); then max_h=$h; fi
done

edp_x=$(( (total_w - internal_w) / 2 ))
set_position "$INTERNAL" "$edp_x" "$max_h"
