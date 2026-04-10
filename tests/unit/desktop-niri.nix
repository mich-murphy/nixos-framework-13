{
  pkgs,
  evalConfig,
}: let
  niriConfig = evalConfig.xdgConfigFiles."niri/config.kdl".source;
  helpers = evalConfig.assertHelpers;
  check = "unit-desktop-niri";
  fix = "modules/home/desktop/niri.nix";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Touchpad ---
    assert_contains "${check}" "${niriConfig}" "natural-scroll" \
      "niri touchpad has natural-scroll" "${fix}"

    # --- Spawn at startup ---
    assert_contains "${check}" "${niriConfig}" "awww-daemon" \
      "niri spawns awww-daemon at startup" "${fix}"
    assert_contains "${check}" "${niriConfig}" "udiskie" \
      "niri spawns udiskie at startup" "${fix}"

    # --- Focus ring color ---
    assert_contains "${check}" "${niriConfig}" "#7dcfff" \
      "niri focus ring active-color is aqua (#7dcfff)" "${fix}"

    # --- Key bindings ---
    assert_contains "${check}" "${niriConfig}" "wezterm" \
      "niri Mod+Return spawns wezterm" "${fix}"
    assert_contains "${check}" "${niriConfig}" "rofi" \
      "niri Mod+Space launches rofi" "${fix}"

    # --- GTK theme ---
    assert_contains "${check}" "${niriConfig}" "Tokyonight-Dark" \
      "niri sets GTK_THEME to Tokyonight-Dark" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
