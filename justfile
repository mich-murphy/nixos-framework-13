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

# ── Interactive VM ───────────────────────────────────────────────

# Run interactive VM with virt-manager (proper keyboard capture)
vm:
    #!/usr/bin/env bash
    set -euo pipefail
    nix build .#user-test-vm -o result-vm

    # Extract paths from the NixOS VM
    SYSTEM=$(readlink -f result-vm/system)
    KERNEL="$SYSTEM/kernel"
    INITRD=$(dirname "$SYSTEM")/initrd  # initrd is sibling to system in the store
    # Find initrd by parsing the run script
    INITRD=$(grep -oP '(?<=-initrd )\S+' result-vm/bin/run-*-vm)
    CMDLINE="$(cat "$SYSTEM/kernel-params") init=$SYSTEM/init console=tty0"

    # Create directories for 9p shared filesystems
    VM_TMP="$PWD/.vm-disks/tmp"
    mkdir -p "$VM_TMP/xchg" "$VM_TMP/shared"

    # Create disk image if missing
    DISK="$PWD/.vm-disks/nixos-test-vm.qcow2"
    mkdir -p "$(dirname "$DISK")"
    if [[ ! -f "$DISK" ]]; then
      echo "Creating VM disk image..."
      qemu-img create -f qcow2 "$DISK" 8G
      # Format as ext4 with nixos label
      TEMP=$(mktemp)
      qemu-img convert -f qcow2 -O raw "$DISK" "$TEMP"
      mkfs.ext4 -L nixos "$TEMP"
      qemu-img convert -f raw -O qcow2 "$TEMP" "$DISK"
      rm "$TEMP"
    fi

    # Generate libvirt XML with NixOS-specific boot config
    sed -e "s|DISK_PATH|$DISK|" \
        -e "s|KERNEL_PATH|$KERNEL|" \
        -e "s|INITRD_PATH|$INITRD|" \
        -e "s|SHARED_DIR|$VM_TMP/shared|" \
        -e "s|XCHG_DIR|$VM_TMP/xchg|" \
        -e "s|CMDLINE|$CMDLINE|" \
        tests/libvirt-vm.xml > /tmp/nixos-test-vm.xml

    virsh -c qemu:///session destroy nixos-test-vm 2>/dev/null || true
    virsh -c qemu:///session undefine nixos-test-vm 2>/dev/null || true
    virsh -c qemu:///session define /tmp/nixos-test-vm.xml
    virsh -c qemu:///session start nixos-test-vm
    virt-manager --connect qemu:///session --show-domain-console nixos-test-vm

# Stop and remove the interactive VM
vm-stop:
    virsh -c qemu:///session destroy nixos-test-vm 2>/dev/null || true
    virsh -c qemu:///session undefine nixos-test-vm 2>/dev/null || true

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

