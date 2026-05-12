# NixOS Framework 13 — development commands
# Context-efficient wrappers: PASS/FAIL summary, detail only on failure.

set shell := ["bash", "-euo", "pipefail", "-c"]

silent := "./scripts/run-silent.sh"
sys := "x86_64-linux"

# ── Aggregate recipes ────────────────────────────────────────────

# Run everything: check + build
all: check build

# ── Formatting / linting ─────────────────────────────────────────

# Format all Nix files and eval-check the flake
check: fmt eval md-lint

# Format all .nix files with alejandra
fmt:
    @{{silent}} "fmt" nix fmt -- .

# Eval-only flake syntax check (no builds)
eval:
    @{{silent}} "eval" nix flake check --no-build

# Lint all Markdown files with markdownlint-cli2
md-lint:
    @{{silent}} "md-lint" nix run nixpkgs#markdownlint-cli2 -- "**/*.md"

# Auto-fix Markdown lint issues where possible
md-fix:
    @{{silent}} "md-fix" nix run nixpkgs#markdownlint-cli2 -- --fix "**/*.md"

# ── Builds ───────────────────────────────────────────────────────

# Build the system configuration + check flake
build: build-system flake-check

# Build the NixOS system configuration
build-system:
    @{{silent}} "build-system" nix build ".#nixosConfigurations.p0ch1t4.config.system.build.toplevel"

# Full flake check (all checks — final gate before commit)
flake-check:
    @{{silent}} "flake-check" nix flake check
