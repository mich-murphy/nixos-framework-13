{
  pkgs,
  evalConfig,
}: let
  direnv = evalConfig.homeConfig.programs.direnv;
  helpers = evalConfig.assertHelpers;
  check = "unit-home-direnv";
  fix = "modules/home/shell/direnv.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    assert_equals "${check}" "${boolStr direnv.enable}" "true" \
      "direnv enabled" "${fix}"
    assert_equals "${check}" "${boolStr direnv.nix-direnv.enable}" "true" \
      "nix-direnv enabled" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
