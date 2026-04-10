{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.programs.ssh;
  helpers = evalConfig.assertHelpers;
  check = "unit-ssh";
  fix = "modules/home/ssh.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
  optOverrides = cfg.extraOptionOverrides;
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- SSH enabled ---
    assert_equals "${check}" "${boolStr cfg.enable}" "true" \
      "ssh client is enabled" "${fix}"

    # --- Hardened crypto ---
    assert_contains "${check}" "${pkgs.writeText "ssh-ciphers" optOverrides.Ciphers}" "chacha20-poly1305@openssh.com" \
      "ssh Ciphers includes chacha20-poly1305" "${fix}"
    assert_contains "${check}" "${pkgs.writeText "ssh-ciphers" optOverrides.Ciphers}" "aes256-gcm@openssh.com" \
      "ssh Ciphers includes aes256-gcm" "${fix}"
    assert_contains "${check}" "${pkgs.writeText "ssh-hostkeyalgs" optOverrides.HostKeyAlgorithms}" "ssh-ed25519" \
      "ssh HostKeyAlgorithms includes ssh-ed25519" "${fix}"
    assert_contains "${check}" "${pkgs.writeText "ssh-kexalgs" optOverrides.KexAlgorithms}" "sntrup761x25519-sha512@openssh.com" \
      "ssh KexAlgorithms includes sntrup761x25519" "${fix}"
    assert_contains "${check}" "${pkgs.writeText "ssh-macs" optOverrides.MACs}" "hmac-sha2-512-etm@openssh.com" \
      "ssh MACs includes hmac-sha2-512-etm" "${fix}"

    # --- Security defaults (from extraOptionOverrides) ---
    assert_equals "${check}" "${optOverrides.AddKeysToAgent}" "confirm" \
      "ssh AddKeysToAgent = confirm" "${fix}"
    assert_equals "${check}" "${optOverrides.VisualHostKey}" "yes" \
      "ssh VisualHostKey = yes" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
