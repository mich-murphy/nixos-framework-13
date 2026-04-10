{
  pkgs,
  evalConfig,
}: let
  cfg = {
    hyprlock = evalConfig.homeConfig.programs.hyprlock;
    hypridle = evalConfig.homeConfig.services.hypridle;
  };
  helpers = evalConfig.assertHelpers;
  check = "unit-desktop-lock";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Hyprlock enabled ---
    assert_equals "${check}" "${boolStr cfg.hyprlock.enable}" "true" \
      "hyprlock is enabled" "modules/home/desktop/hyprlock.nix"

    # --- Hyprlock fingerprint auth ---
    assert_equals "${check}" "${boolStr (builtins.elemAt cfg.hyprlock.settings.auth 0).fingerprint.enabled}" "true" \
      "hyprlock fingerprint auth is enabled" "modules/home/desktop/hyprlock.nix"

    # --- Hyprlock background blur ---
    assert_equals "${check}" "${toString (builtins.elemAt cfg.hyprlock.settings.background 0).blur_passes}" "3" \
      "hyprlock background blur_passes = 3" "modules/home/desktop/hyprlock.nix"

    # --- Hypridle enabled ---
    assert_equals "${check}" "${boolStr cfg.hypridle.enable}" "true" \
      "hypridle is enabled" "modules/home/desktop/hypridle.nix"

    # --- Hypridle listener count ---
    assert_equals "${check}" "${toString (builtins.length cfg.hypridle.settings.listener)}" "5" \
      "hypridle has 5 listeners" "modules/home/desktop/hypridle.nix"

    # --- Hypridle timeouts ---
    assert_equals "${check}" "${toString (builtins.elemAt cfg.hypridle.settings.listener 0).timeout}" "150" \
      "hypridle first listener timeout = 150 (dim screen)" "modules/home/desktop/hypridle.nix"
    assert_equals "${check}" "${toString (builtins.elemAt cfg.hypridle.settings.listener 2).timeout}" "300" \
      "hypridle third listener timeout = 300 (lock session)" "modules/home/desktop/hypridle.nix"
    assert_equals "${check}" "${toString (builtins.elemAt cfg.hypridle.settings.listener 4).timeout}" "1800" \
      "hypridle fifth listener timeout = 1800 (suspend)" "modules/home/desktop/hypridle.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
