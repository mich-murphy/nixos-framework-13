{
  pkgs,
  evalConfig,
}: let
  homePkgs = evalConfig.homeConfig.home.packages;
  helpers = evalConfig.assertHelpers;
  check = "unit-home-apps";
  fix = "modules/home/apps.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
  hasPkg = name: builtins.any (p: (builtins.tryEval (pkgs.lib.getName p)).value == name) homePkgs;
in
  pkgs.runCommand check {} ''
    source ${helpers}

    assert_equals "${check}" "${boolStr (hasPkg "obsidian")}" "true" \
      "obsidian installed" "${fix}"
    assert_equals "${check}" "${boolStr (hasPkg "zotero")}" "true" \
      "zotero installed" "${fix}"
    assert_equals "${check}" "${boolStr (hasPkg "dolphin")}" "true" \
      "dolphin installed" "${fix}"
    assert_equals "${check}" "${boolStr (hasPkg "vlc")}" "true" \
      "vlc installed" "${fix}"
    assert_equals "${check}" "${boolStr (hasPkg "gimp")}" "true" \
      "gimp installed" "${fix}"
    assert_equals "${check}" "${boolStr (hasPkg "owncloud-client")}" "true" \
      "owncloud-client installed" "${fix}"
    assert_equals "${check}" "${boolStr (hasPkg "neovim")}" "true" \
      "neovim installed" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
