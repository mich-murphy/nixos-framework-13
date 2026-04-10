{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-gtk";
  fix = "modules/home/desktop/gtk.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- GTK theme ---
    assert_equals "${check}" "${boolStr cfg.gtk.enable}" "true" \
      "GTK theming enabled" "${fix}"
    assert_equals "${check}" "${cfg.gtk.theme.name}" "Tokyonight-Dark" \
      "GTK theme = Tokyonight-Dark" "${fix}"
    assert_equals "${check}" "${cfg.gtk.cursorTheme.name}" "Bibata-Modern-Classic" \
      "cursor theme = Bibata-Modern-Classic" "${fix}"
    assert_equals "${check}" "${toString cfg.gtk.cursorTheme.size}" "20" \
      "cursor size = 20" "${fix}"
    assert_equals "${check}" "${cfg.gtk.font.name}" "JetBrainsMono Nerd Font" \
      "GTK font = JetBrainsMono Nerd Font" "${fix}"
    assert_equals "${check}" "${toString cfg.gtk.font.size}" "10" \
      "GTK font size = 10" "${fix}"

    # --- Pointer cursor (Wayland) ---
    assert_equals "${check}" "${cfg.home.pointerCursor.name}" "Bibata-Modern-Classic" \
      "pointer cursor = Bibata-Modern-Classic" "${fix}"
    assert_equals "${check}" "${toString cfg.home.pointerCursor.size}" "20" \
      "pointer cursor size = 20" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
