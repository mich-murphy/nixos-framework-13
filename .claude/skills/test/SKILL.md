---
name: test
description: Run unit and integration tests for changed .nix files using the justfile
---

Run the test workflow for any `.nix` files changed in this session.

## Steps

1. **Run all unit tests** — they are eval-only and fast:
   ```
   just unit
   ```

2. **Identify mapped integration tests** — read `tests/MODULE_MAP.nix` → `integrationMap` and find entries matching the changed file(s). If a changed file has no mapping, skip integration tests for it.

3. **Run mapped integration tests** — for each mapped test name:
   ```
   just integration-one <name>
   ```

4. **On failure** — read the FAIL output for expected/actual values, fix the issue, then re-run only the failing test:
   ```
   just unit-one <name>
   just integration-one <name>
   ```
   Repeat until the failing test passes, then re-run the full tier (`just unit` or `just integration`) to check for regressions.

5. **Do NOT run `just flake-check`** — that is a final gate before commit, not part of the edit-test loop.
