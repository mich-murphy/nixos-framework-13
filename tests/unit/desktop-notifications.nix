{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.services.mako;
  helpers = evalConfig.assertHelpers;
  check = "unit-desktop-notifications";
  fix = "modules/home/desktop/mako.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Mako enabled ---
    assert_equals "${check}" "${boolStr cfg.enable}" "true" \
      "mako notification daemon is enabled" "${fix}"

    # --- Mako settings ---
    assert_equals "${check}" "${toString cfg.settings.default-timeout}" "3000" \
      "mako default-timeout = 3000" "${fix}"
    assert_equals "${check}" "${cfg.settings.anchor}" "top-right" \
      "mako anchor = top-right" "${fix}"
    assert_equals "${check}" "${toString cfg.settings.max-visible}" "10" \
      "mako max-visible = 10" "${fix}"

    # --- Mako colors ---
    assert_equals "${check}" "${cfg.settings.background-color}" "#1a1b26" \
      "mako background-color = #1a1b26 (bg)" "${fix}"
    assert_equals "${check}" "${cfg.settings.text-color}" "#c0caf5" \
      "mako text-color = #c0caf5 (fg)" "${fix}"

    # --- Mako font ---
    assert_contains "${check}" "${pkgs.writeText "mako-font" cfg.settings.font}" "JetBrainsMono" \
      "mako font contains JetBrainsMono" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
