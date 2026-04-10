{
  pkgs,
  evalConfig,
}: let
  fishTheme = evalConfig.xdgConfigFiles."fish/themes/tokyonight_night.theme".source;
  niriConfig = evalConfig.xdgConfigFiles."niri/config.kdl".source;
  btopTheme = evalConfig.xdgConfigFiles."btop/themes/tokyonight.theme".source;
  rofiTheme = evalConfig.xdgDataFiles."rofi/themes/tokyonight-night.rasi".source;
  yaziTheme = evalConfig.xdgConfigFiles."yazi/theme.toml".source;
  waybarStyle = pkgs.writeText "waybar-style" evalConfig.homeConfig.programs.waybar.style;
  helpers = evalConfig.assertHelpers;
  check = "unit-theme-propagation";
  fix = "theme/tokyonight.nix";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # Verify Tokyo Night bg (#1a1b26) propagates to multiple configs
    assert_contains "${check}" "${btopTheme}" '#1a1b26' \
      "Tokyo Night bg (#1a1b26) in btop theme" "${fix}"
    assert_contains "${check}" "${waybarStyle}" '#1a1b26' \
      "Tokyo Night bg (#1a1b26) in waybar CSS" "${fix}"
    assert_contains "${check}" "${rofiTheme}" '#1a1b26' \
      "Tokyo Night bg (#1a1b26) in rofi theme" "${fix}"

    # Verify Tokyo Night fg (#c0caf5) propagates
    assert_contains "${check}" "${fishTheme}" 'c0caf5' \
      "Tokyo Night fg (c0caf5) in fish theme (without #)" "${fix}"
    assert_contains "${check}" "${btopTheme}" '#c0caf5' \
      "Tokyo Night fg (#c0caf5) in btop theme" "${fix}"
    assert_contains "${check}" "${rofiTheme}" '#c0caf5' \
      "Tokyo Night fg (#c0caf5) in rofi theme" "${fix}"

    # Verify Tokyo Night aqua (#7dcfff) propagates
    assert_contains "${check}" "${fishTheme}" '7dcfff' \
      "Tokyo Night aqua (7dcfff) in fish theme" "${fix}"
    assert_contains "${check}" "${niriConfig}" '#7dcfff' \
      "Tokyo Night aqua (#7dcfff) in niri focus ring" "${fix}"

    # Verify Tokyo Night purple (#bb9af7) propagates
    assert_contains "${check}" "${fishTheme}" 'bb9af7' \
      "Tokyo Night purple (bb9af7) in fish theme" "${fix}"
    assert_contains "${check}" "${rofiTheme}" '#bb9af7' \
      "Tokyo Night purple (#bb9af7) in rofi theme" "${fix}"
    assert_contains "${check}" "${waybarStyle}" '#bb9af7' \
      "Tokyo Night purple (#bb9af7) in waybar CSS" "${fix}"

    # Verify Tokyo Night teal (#27a1b9) propagates
    assert_contains "${check}" "${yaziTheme}" '#27a1b9' \
      "Tokyo Night teal (#27a1b9) in yazi theme" "${fix}"
    assert_contains "${check}" "${btopTheme}" '#27a1b9' \
      "Tokyo Night teal (#27a1b9) in btop theme" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
