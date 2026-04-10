{
  pkgs,
  evalConfig,
}: let
  bat = evalConfig.homeConfig.programs.bat;
  eza = evalConfig.homeConfig.programs.eza;
  fzf = evalConfig.homeConfig.programs.fzf;
  zoxide = evalConfig.homeConfig.programs.zoxide;
  btop = evalConfig.homeConfig.programs.btop;
  lazygit = evalConfig.homeConfig.programs.lazygit;
  btopTheme = evalConfig.xdgConfigFiles."btop/themes/tokyonight.theme".source;
  helpers = evalConfig.assertHelpers;
  check = "unit-cli-tools";
  fix = "modules/home/shell/cli.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
  fzfOptsFile = pkgs.writeText "fzf-opts" (builtins.concatStringsSep "\n" fzf.defaultOptions);
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Bat ---
    assert_equals "${check}" "${boolStr bat.enable}" "true" \
      "bat is enabled" "${fix}"
    assert_equals "${check}" "${bat.config.theme}" "tokyonight_night" \
      "bat theme is tokyonight_night" "${fix}"

    # --- Eza ---
    assert_equals "${check}" "${boolStr eza.enable}" "true" \
      "eza is enabled" "${fix}"
    assert_equals "${check}" "${eza.icons}" "auto" \
      "eza icons = auto" "${fix}"

    # --- Fzf ---
    assert_equals "${check}" "${boolStr fzf.enable}" "true" \
      "fzf is enabled" "${fix}"
    assert_contains "${check}" "${fzfOptsFile}" "layout=reverse" \
      "fzf layout is reverse" "${fix}"
    assert_contains "${check}" "${fzfOptsFile}" "bg:#16161e" \
      "fzf bg color is Tokyo Night bg_dark" "${fix}"
    assert_contains "${check}" "${fzfOptsFile}" "pointer:#ff007c" \
      "fzf pointer color is Tokyo Night magenta" "${fix}"

    # --- Zoxide ---
    assert_equals "${check}" "${boolStr zoxide.enable}" "true" \
      "zoxide is enabled" "${fix}"

    # --- Btop ---
    assert_equals "${check}" "${boolStr btop.enable}" "true" \
      "btop is enabled" "${fix}"
    assert_equals "${check}" "${boolStr btop.settings.vim_keys}" "true" \
      "btop vim_keys = true" "${fix}"
    assert_contains "${check}" "${btopTheme}" "theme[main_bg]=\"#1a1b26\"" \
      "btop theme main_bg is Tokyo Night bg" "${fix}"

    # --- Lazygit ---
    assert_equals "${check}" "${boolStr lazygit.enable}" "true" \
      "lazygit is enabled" "${fix}"
    assert_equals "${check}" "${lazygit.settings.gui.nerdFontsVersion}" "3" \
      "lazygit nerdFontsVersion = 3" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
