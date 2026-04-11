# NixOS Framework 13 — development commands
# Context-efficient wrappers: PASS/FAIL summary, detail only on failure.

set shell := ["bash", "-euo", "pipefail", "-c"]

silent := "./scripts/run-silent.sh"
sys := "x86_64-linux"

# ── Aggregate recipes ────────────────────────────────────────────

# Run everything: check + test + build
all: check test build

# ── Formatting / linting ─────────────────────────────────────────

# Format all Nix files and eval-check the flake
check: fmt eval

# Format all .nix files with alejandra
fmt:
    @{{silent}} "fmt" nix fmt -- .

# Eval-only flake syntax check (no builds)
eval:
    @{{silent}} "eval" nix flake check --no-build

# ── Tests ────────────────────────────────────────────────────────

# Run all unit + integration tests
test: unit integration

# Run all unit tests (eval-only, fast)
unit:
    #!/usr/bin/env bash
    set -euo pipefail
    tests=$(nix eval --raw '.#checks.{{sys}}' --apply 'cs: builtins.concatStringsSep "\n" (builtins.filter (n: builtins.substring 0 5 n == "unit-") (builtins.attrNames cs))')
    while IFS= read -r t; do
      [[ -n "$t" ]] || continue
      {{silent}} "$t" nix build ".#checks.{{sys}}.$t"
    done <<< "$tests"

# Run a single unit test by name (e.g. just unit-one unit-shell)
unit-one name:
    @{{silent}} "{{name}}" nix build ".#checks.{{sys}}.{{name}}"

# Run all integration tests (VM-based, slow)
integration:
    #!/usr/bin/env bash
    set -euo pipefail
    tests=$(nix eval --raw '.#checks.{{sys}}' --apply 'cs: builtins.concatStringsSep "\n" (builtins.filter (n: builtins.substring 0 12 n == "integration-") (builtins.attrNames cs))')
    while IFS= read -r t; do
      [[ -n "$t" ]] || continue
      {{silent}} "$t" nix build ".#checks.{{sys}}.$t"
    done <<< "$tests"

# Run a single integration test by name (e.g. just integration-one integration-login)
integration-one name:
    @{{silent}} "{{name}}" nix build ".#checks.{{sys}}.{{name}}"

# ── Builds ───────────────────────────────────────────────────────

# Build the system configuration + check flake
build: build-system flake-check

# Build the NixOS system configuration
build-system:
    @{{silent}} "build-system" nix build ".#nixosConfigurations.p0ch1t4.config.system.build.toplevel"

# Full flake check (all checks — final gate before commit)
flake-check:
    @{{silent}} "flake-check" nix flake check


