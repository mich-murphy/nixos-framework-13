{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.nixosConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-nixos-security";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Sudo ---
    assert_equals "${check}" "${boolStr cfg.security.sudo.execWheelOnly}" "true" \
      "sudo execWheelOnly = true" "modules/nixos/security.nix"

    # --- Kernel hardening ---
    assert_equals "${check}" "${toString cfg.boot.kernel.sysctl."kernel.unprivileged_bpf_disabled"}" "1" \
      "kernel.unprivileged_bpf_disabled = 1" "modules/nixos/security.nix"
    assert_equals "${check}" "${toString cfg.boot.kernel.sysctl."net.core.bpf_jit_harden"}" "2" \
      "net.core.bpf_jit_harden = 2" "modules/nixos/security.nix"

    # --- SSH agent ---
    assert_equals "${check}" "${boolStr cfg.programs.ssh.startAgent}" "true" \
      "ssh-agent enabled" "modules/nixos/security.nix"

    # --- Firewall ---
    assert_equals "${check}" "${boolStr cfg.networking.firewall.enable}" "true" \
      "firewall enabled" "modules/nixos/networking.nix"
    assert_equals "${check}" "${boolStr cfg.networking.firewall.allowPing}" "false" \
      "firewall allowPing = false" "modules/nixos/networking.nix"
    assert_equals "${check}" "${boolStr cfg.networking.nftables.enable}" "true" \
      "nftables enabled" "modules/nixos/networking.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
