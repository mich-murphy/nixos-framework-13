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
check: fmt eval

# Format all .nix files with alejandra
fmt:
    @{{silent}} "fmt" nix fmt -- .

# Eval-only flake syntax check (no builds)
eval:
    @{{silent}} "eval" nix flake check --no-build

# ── Builds ───────────────────────────────────────────────────────

# Build the system configuration + check flake
build: build-system flake-check

# Build the NixOS system configuration
build-system:
    @{{silent}} "build-system" nix build ".#nixosConfigurations.p0ch1t4.config.system.build.toplevel"

# Full flake check (all checks — final gate before commit)
flake-check:
    @{{silent}} "flake-check" nix flake check

# ── Installation ─────────────────────────────────────────────────

# Install NixOS to this machine via nixos-anywhere kexec (DESTRUCTIVE)
install:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "WARNING: This will ERASE ALL DATA on /dev/nvme0n1"
    read -p "Type 'yes' to continue: " confirm
    [[ "$confirm" == "yes" ]] || { echo "Aborted."; exit 1; }
    read -s -p "Enter LUKS passphrase for disk encryption: " luks_pass
    echo
    nix run github:nix-community/nixos-anywhere -- \
      --flake .#p0ch1t4 \
      --disk-encryption-keys /tmp/disk.key <(echo -n "$luks_pass") \
      root@localhost
