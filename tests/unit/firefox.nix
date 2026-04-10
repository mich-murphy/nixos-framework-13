{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.programs.firefox;
  settings = cfg.profiles.default.settings;
  helpers = evalConfig.assertHelpers;
  check = "unit-firefox";
  fix = "modules/home/firefox.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Firefox enabled ---
    assert_equals "${check}" "${boolStr cfg.enable}" "true" \
      "firefox is enabled" "${fix}"

    # --- Privacy & security settings ---
    assert_equals "${check}" "${boolStr settings."dom.security.https_only_mode"}" "true" \
      "firefox https_only_mode = true" "${fix}"
    assert_equals "${check}" "${toString settings."network.trr.mode"}" "3" \
      "firefox DNS-over-HTTPS TRR mode = 3" "${fix}"
    assert_contains "${check}" "${pkgs.writeText "trr-uri" settings."network.trr.uri"}" "quad9" \
      "firefox TRR URI uses Quad9" "${fix}"
    assert_equals "${check}" "${boolStr settings."toolkit.telemetry.enabled"}" "false" \
      "firefox telemetry disabled" "${fix}"
    assert_equals "${check}" "${boolStr settings."datareporting.healthreport.uploadEnabled"}" "false" \
      "firefox health report upload disabled" "${fix}"

    # --- Content blocking ---
    assert_equals "${check}" "${settings."browser.contentblocking.category"}" "strict" \
      "firefox content blocking = strict" "${fix}"

    # --- UI ---
    assert_equals "${check}" "${boolStr settings."sidebar.verticalTabs"}" "true" \
      "firefox vertical tabs enabled" "${fix}"

    # --- Autofill & passwords ---
    assert_equals "${check}" "${boolStr settings."signon.rememberSignons"}" "false" \
      "firefox password saving disabled (using 1Password)" "${fix}"

    # --- Privacy ---
    assert_equals "${check}" "${boolStr settings."privacy.userContext.enabled"}" "true" \
      "firefox container tabs enabled" "${fix}"
    assert_equals "${check}" "${boolStr settings."privacy.globalprivacycontrol.enabled"}" "true" \
      "firefox Global Privacy Control enabled" "${fix}"

    # --- Search ---
    assert_equals "${check}" "${cfg.profiles.default.search.default}" "ddg" \
      "firefox default search engine = ddg" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
