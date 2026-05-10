#!/usr/bin/env bash
# Watch niri's IPC event stream and re-run niri-arrange-outputs whenever an
# output-related event arrives. Relies on arrange-outputs being idempotent
# (skip-if-equal) so the events emitted by our own position changes do not
# loop. Reconnects to the stream if it drops.
set -uo pipefail

while true; do
    while IFS= read -r event; do
        if [[ "$event" == *Output* ]]; then
            niri-arrange-outputs >/dev/null 2>&1 || true
        fi
    done < <(niri msg event-stream 2>/dev/null)
    sleep 1
done
