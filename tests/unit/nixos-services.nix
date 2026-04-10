{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.nixosConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-nixos-services";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- OpenSSH ---
    assert_equals "${check}" "${boolStr cfg.services.openssh.enable}" "true" \
      "openssh enabled" "modules/nixos/openssh.nix"
    assert_equals "${check}" "${boolStr cfg.services.openssh.openFirewall}" "false" \
      "openssh openFirewall = false" "modules/nixos/openssh.nix"
    assert_equals "${check}" "${boolStr cfg.services.openssh.settings.PasswordAuthentication}" "false" \
      "openssh PasswordAuthentication = false" "modules/nixos/openssh.nix"
    assert_equals "${check}" "${cfg.services.openssh.settings.PermitRootLogin}" "no" \
      "openssh PermitRootLogin = no" "modules/nixos/openssh.nix"
    assert_equals "${check}" "${boolStr cfg.services.openssh.settings.X11Forwarding}" "false" \
      "openssh X11Forwarding = false" "modules/nixos/openssh.nix"
    assert_equals "${check}" "${boolStr cfg.services.openssh.settings.AllowAgentForwarding}" "false" \
      "openssh AllowAgentForwarding = false" "modules/nixos/openssh.nix"

    # --- PipeWire ---
    assert_equals "${check}" "${boolStr cfg.services.pipewire.enable}" "true" \
      "pipewire enabled" "modules/nixos/audio.nix"
    assert_equals "${check}" "${boolStr cfg.services.pipewire.alsa.enable}" "true" \
      "pipewire ALSA enabled" "modules/nixos/audio.nix"
    assert_equals "${check}" "${boolStr cfg.services.pipewire.pulse.enable}" "true" \
      "pipewire PulseAudio enabled" "modules/nixos/audio.nix"
    assert_equals "${check}" "${boolStr cfg.services.pipewire.wireplumber.enable}" "true" \
      "wireplumber enabled" "modules/nixos/audio.nix"
    assert_equals "${check}" "${boolStr cfg.security.rtkit.enable}" "true" \
      "rtkit enabled (for pipewire)" "modules/nixos/audio.nix"

    # --- Docker ---
    assert_equals "${check}" "${boolStr cfg.virtualisation.docker.rootless.enable}" "true" \
      "docker rootless enabled" "modules/nixos/docker.nix"
    assert_equals "${check}" "${boolStr cfg.virtualisation.docker.rootless.setSocketVariable}" "true" \
      "docker rootless socket variable set" "modules/nixos/docker.nix"
    assert_equals "${check}" "${boolStr cfg.virtualisation.docker.autoPrune.enable}" "true" \
      "docker auto-prune enabled" "modules/nixos/docker.nix"

    # --- Bluetooth ---
    assert_equals "${check}" "${boolStr cfg.hardware.bluetooth.enable}" "true" \
      "bluetooth enabled" "modules/nixos/bluetooth.nix"
    assert_equals "${check}" "${boolStr cfg.hardware.bluetooth.powerOnBoot}" "false" \
      "bluetooth powerOnBoot = false" "modules/nixos/bluetooth.nix"
    assert_equals "${check}" "${boolStr cfg.services.blueman.enable}" "true" \
      "blueman enabled" "modules/nixos/bluetooth.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
