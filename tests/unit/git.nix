{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.homeConfig.programs.git;
  delta = evalConfig.homeConfig.programs.delta;
  gitattributes = evalConfig.xdgConfigFiles."git/attributes".source;
  helpers = evalConfig.assertHelpers;
  check = "unit-git";
  fix = "modules/home/git.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Git identity ---
    assert_equals "${check}" "${cfg.settings.user.name}" "Michael Murphy" \
      "git user.name = Michael Murphy" "${fix}"
    assert_equals "${check}" "${cfg.settings.user.email}" "github@elmurphy.com" \
      "git user.email = github@elmurphy.com" "${fix}"

    # --- Core settings ---
    assert_equals "${check}" "${toString cfg.settings.init.defaultBranch}" "main" \
      "git init.defaultBranch = main" "${fix}"
    assert_equals "${check}" "${boolStr cfg.settings.pull.rebase}" "true" \
      "git pull.rebase = true" "${fix}"
    assert_equals "${check}" "${cfg.settings.diff.algorithm}" "histogram" \
      "git diff.algorithm = histogram" "${fix}"
    assert_equals "${check}" "${boolStr cfg.settings.rerere.enabled}" "true" \
      "git rerere.enabled = true" "${fix}"
    assert_equals "${check}" "${cfg.settings.merge.conflictStyle}" "zdiff3" \
      "git merge.conflictStyle = zdiff3" "${fix}"

    # --- Git attributes ---
    assert_contains "${check}" "${gitattributes}" '*.py diff=python' \
      "git attributes: python diff driver" "${fix}"
    assert_contains "${check}" "${gitattributes}" '*.rs diff=rust' \
      "git attributes: rust diff driver" "${fix}"
    assert_contains "${check}" "${gitattributes}" '*.jpg diff=exiftool' \
      "git attributes: exiftool diff driver for images" "${fix}"
    assert_contains "${check}" "${gitattributes}" '*.docx diff=pandoc-to-markdown' \
      "git attributes: pandoc diff driver for documents" "${fix}"

    # --- Delta integration ---
    assert_equals "${check}" "${boolStr delta.enable}" "true" \
      "delta diff tool enabled" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
