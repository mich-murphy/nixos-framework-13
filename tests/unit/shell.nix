{
  pkgs,
  evalConfig,
}: let
  fish = evalConfig.homeConfig.programs.fish;
  starship = evalConfig.homeConfig.programs.starship;
  direnv = evalConfig.homeConfig.programs.direnv;
  fishTheme = evalConfig.xdgConfigFiles."fish/themes/tokyonight_night.theme".source;
  helpers = evalConfig.assertHelpers;
  check = "unit-shell";
  boolStr = b:
    if b
    then "true"
    else "false";
  interactiveInit = pkgs.writeText "fish-interactive-init" fish.interactiveShellInit;
  loginInit = pkgs.writeText "fish-login-init" fish.loginShellInit;
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Fish shell ---
    assert_equals "${check}" "${boolStr fish.enable}" "true" \
      "fish shell is enabled" "modules/home/shell/fish.nix"
    assert_contains "${check}" "${interactiveInit}" "fish_vi_key_bindings" \
      "fish interactiveShellInit sets vi key bindings" "modules/home/shell/fish.nix"
    assert_contains "${check}" "${interactiveInit}" "fish_greeting" \
      "fish interactiveShellInit sets empty greeting" "modules/home/shell/fish.nix"
    assert_contains "${check}" "${loginInit}" "BROWSER firefox" \
      "fish loginShellInit sets BROWSER to firefox" "modules/home/shell/fish.nix"
    assert_equals "${check}" "${fish.shellAliases.cat}" "bat" \
      "fish alias cat=bat" "modules/home/shell/fish.nix"

    # --- Fish Tokyo Night theme ---
    assert_contains "${check}" "${fishTheme}" "fish_color_normal c0caf5" \
      "fish theme: normal color is fg" "modules/home/shell/fish.nix"
    assert_contains "${check}" "${fishTheme}" "fish_color_command 7dcfff" \
      "fish theme: command color is aqua" "modules/home/shell/fish.nix"
    assert_contains "${check}" "${fishTheme}" "fish_color_error f7768e" \
      "fish theme: error color is red" "modules/home/shell/fish.nix"
    assert_contains "${check}" "${fishTheme}" "fish_color_keyword bb9af7" \
      "fish theme: keyword color is purple" "modules/home/shell/fish.nix"

    # --- Starship ---
    assert_equals "${check}" "${boolStr starship.enable}" "true" \
      "starship prompt is enabled" "modules/home/shell/starship.nix"

    # --- Direnv ---
    assert_equals "${check}" "${boolStr direnv.enable}" "true" \
      "direnv is enabled" "modules/home/shell/direnv.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
