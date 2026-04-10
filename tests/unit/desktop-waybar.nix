{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.programs.waybar;
  waybarStyle = pkgs.writeText "waybar-style" cfg.style;
  helpers = evalConfig.assertHelpers;
  check = "unit-desktop-waybar";
  fix = "modules/home/desktop/waybar.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Waybar enabled ---
    assert_equals "${check}" "${boolStr cfg.enable}" "true" \
      "waybar is enabled" "${fix}"

    # --- CSS style colors ---
    assert_contains "${check}" "${waybarStyle}" "background: #1a1b26" \
      "waybar CSS has background: #1a1b26 (bg color)" "${fix}"
    assert_contains "${check}" "${waybarStyle}" "#bb9af7" \
      "waybar CSS has #bb9af7 (purple for active workspaces)" "${fix}"
    assert_contains "${check}" "${waybarStyle}" "#7aa2f7" \
      "waybar CSS has #7aa2f7 (blue for battery/backlight)" "${fix}"

    # --- Module layout ---
    assert_equals "${check}" "${boolStr (builtins.elem "niri/workspaces" cfg.settings.mainBar.modules-left)}" "true" \
      "waybar modules-left contains niri/workspaces" "${fix}"
    assert_equals "${check}" "${boolStr (builtins.elem "clock" cfg.settings.mainBar.modules-center)}" "true" \
      "waybar modules-center contains clock" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
