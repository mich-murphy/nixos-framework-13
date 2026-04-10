{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig;
  yaziTheme = evalConfig.xdgConfigFiles."yazi/theme.toml".source;
  helpers = evalConfig.assertHelpers;
  check = "unit-media";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Zathura ---
    assert_equals "${check}" "${boolStr cfg.programs.zathura.enable}" "true" \
      "zathura enabled" "modules/home/media.nix"
    assert_equals "${check}" "${boolStr cfg.programs.zathura.options.recolor}" "true" \
      "zathura recolor = true" "modules/home/media.nix"
    assert_equals "${check}" "${cfg.programs.zathura.options.selection-clipboard}" "clipboard" \
      "zathura selection-clipboard = clipboard" "modules/home/media.nix"
    assert_equals "${check}" "${cfg.programs.zathura.mappings.K}" "zoom in" \
      "zathura K = zoom in" "modules/home/media.nix"
    assert_equals "${check}" "${cfg.programs.zathura.mappings.J}" "zoom out" \
      "zathura J = zoom out" "modules/home/media.nix"
    assert_equals "${check}" "${cfg.programs.zathura.options.default-bg}" "#1a1b26" \
      "zathura default-bg = Tokyo Night bg" "modules/home/media.nix"
    assert_equals "${check}" "${cfg.programs.zathura.options.default-fg}" "#c0caf5" \
      "zathura default-fg = Tokyo Night fg" "modules/home/media.nix"

    # --- Yazi ---
    assert_equals "${check}" "${boolStr cfg.programs.yazi.enable}" "true" \
      "yazi enabled" "modules/home/media.nix"
    assert_contains "${check}" "${yaziTheme}" '#a9b1d6' \
      "yazi theme: cwd uses fg_dark color" "modules/home/media.nix"
    assert_contains "${check}" "${yaziTheme}" '#292e42' \
      "yazi theme: hovered uses bg1 color" "modules/home/media.nix"
    assert_contains "${check}" "${yaziTheme}" '#9ece6a' \
      "yazi theme: marker_copied uses green" "modules/home/media.nix"
    assert_contains "${check}" "${yaziTheme}" '#f7768e' \
      "yazi theme: marker_cut uses red" "modules/home/media.nix"
    assert_contains "${check}" "${yaziTheme}" '#bb9af7' \
      "yazi theme: marker_marked uses purple" "modules/home/media.nix"

    # --- mpv ---
    assert_equals "${check}" "${boolStr cfg.programs.mpv.enable}" "true" \
      "mpv enabled" "modules/home/media.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
