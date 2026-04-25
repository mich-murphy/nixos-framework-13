{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.nixosConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-nixos-power";
  fix = "modules/nixos/power.nix";
  login = cfg.services.logind.settings.Login;
in
  pkgs.runCommand check {} ''
    source ${helpers}

    assert_equals "${check}" "${login.HandleLidSwitch}" "suspend" \
      "lid switch suspends on battery" "${fix}"
    assert_equals "${check}" "${login.HandleLidSwitchExternalPower}" "suspend" \
      "lid switch suspends on AC power" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
