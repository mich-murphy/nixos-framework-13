{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.nixosConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-nixos-virtualisation";
  fix = "modules/nixos/virtualisation.nix";
  boolStr = b:
    if b
    then "true"
    else "false";
  userGroups = cfg.users.users.michael.extraGroups;
  hasGroup = g: builtins.elem g userGroups;
in
  pkgs.runCommand check {} ''
    source ${helpers}

    assert_equals "${check}" "${boolStr cfg.virtualisation.libvirtd.enable}" "true" \
      "libvirtd enabled" "${fix}"
    assert_equals "${check}" "${boolStr cfg.programs.virt-manager.enable}" "true" \
      "virt-manager enabled" "${fix}"
    assert_equals "${check}" "${boolStr (hasGroup "libvirtd")}" "true" \
      "michael in libvirtd group" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
