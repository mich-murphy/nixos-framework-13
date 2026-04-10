{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.programs;
  weztermConfig = pkgs.writeText "wezterm-config" cfg.wezterm.extraConfig;
  ghostty = cfg.ghostty;
  ghosttySettings = ghostty.settings;
  helpers = evalConfig.assertHelpers;
  check = "unit-terminals";
  boolStr = b:
    if b
    then "true"
    else "false";
  # Ghostty settings values are stored as lists; extract the first element
  ghosttyVal = key: builtins.head ghosttySettings.${key};
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Wezterm ---
    assert_contains "${check}" "${weztermConfig}" 'key = "a", mods = "CTRL"' \
      "wezterm leader key is Ctrl+a" "modules/home/terminals/wezterm.nix"
    assert_contains "${check}" "${weztermConfig}" 'color_scheme = "Tokyo Night"' \
      "wezterm color scheme is Tokyo Night" "modules/home/terminals/wezterm.nix"
    assert_contains "${check}" "${weztermConfig}" 'font("JetBrainsMono Nerd Font")' \
      "wezterm font is JetBrainsMono Nerd Font" "modules/home/terminals/wezterm.nix"
    assert_contains "${check}" "${weztermConfig}" 'SplitHorizontal' \
      "wezterm has horizontal split binding" "modules/home/terminals/wezterm.nix"

    # --- Ghostty ---
    assert_equals "${check}" "${boolStr ghostty.enable}" "true" \
      "ghostty is enabled" "modules/home/terminals/ghostty.nix"
    assert_equals "${check}" "${ghosttyVal "theme"}" "TokyoNight Night" \
      "ghostty theme is TokyoNight Night" "modules/home/terminals/ghostty.nix"
    assert_equals "${check}" "${ghosttyVal "font-family"}" "JetBrainsMono Nerd Font" \
      "ghostty font is JetBrainsMono Nerd Font" "modules/home/terminals/ghostty.nix"
    assert_equals "${check}" "${toString (ghosttyVal "font-size")}" "10" \
      "ghostty font size is 10" "modules/home/terminals/ghostty.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
