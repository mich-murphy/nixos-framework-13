{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.nixosConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-nixos-hardware";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Power Profiles Daemon (for waybar power-profiles-daemon module) ---
    assert_equals "${check}" "${boolStr cfg.services.power-profiles-daemon.enable}" "true" \
      "power-profiles-daemon enabled" "modules/nixos/hardware.nix"

    # --- UPower (for waybar battery module) ---
    assert_equals "${check}" "${boolStr cfg.services.upower.enable}" "true" \
      "upower enabled" "modules/nixos/hardware.nix"

    # --- Graphics ---
    assert_equals "${check}" "${boolStr cfg.hardware.graphics.enable}" "true" \
      "hardware graphics enabled" "modules/nixos/hardware.nix"

    # --- Firmware updates ---
    assert_equals "${check}" "${boolStr cfg.services.fwupd.enable}" "true" \
      "fwupd enabled" "modules/nixos/hardware.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
