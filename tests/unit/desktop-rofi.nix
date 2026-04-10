{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.programs.rofi;
  themeFile = evalConfig.xdgDataFiles."rofi/themes/tokyonight-night.rasi".source;
  layoutFile = evalConfig.xdgDataFiles."rofi/minimal.rasi".source;
  helpers = evalConfig.assertHelpers;
  check = "unit-desktop-rofi";
  fix = "modules/home/desktop/rofi.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Rofi enabled ---
    assert_equals "${check}" "${boolStr cfg.enable}" "true" \
      "rofi is enabled" "${fix}"

    # --- Theme colors ---
    assert_contains "${check}" "${themeFile}" "bg0:    #1a1b26" \
      "rofi theme has bg0: #1a1b26 (bg color)" "${fix}"
    assert_contains "${check}" "${themeFile}" "purple: #bb9af7" \
      "rofi theme has purple: #bb9af7" "${fix}"

    # --- Minimal layout ---
    assert_contains "${check}" "${layoutFile}" "JetBrainsMono Nerd Font" \
      "rofi minimal layout uses JetBrainsMono Nerd Font" "${fix}"
    assert_contains "${check}" "${layoutFile}" "500px" \
      "rofi minimal layout window width is 500px" "${fix}"
    assert_contains "${check}" "${layoutFile}" "@purple" \
      "rofi minimal layout border-color references @purple" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
