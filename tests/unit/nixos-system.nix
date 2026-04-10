{
  pkgs,
  evalConfig,
}: let
  cfg = evalConfig.nixosConfig;
  helpers = evalConfig.assertHelpers;
  check = "unit-nixos-system";
  boolStr = b:
    if b
    then "true"
    else "false";
  userGroups = cfg.users.users.michael.extraGroups;
  hasGroup = g: builtins.elem g userGroups;
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- Locale ---
    assert_equals "${check}" "${cfg.time.timeZone}" "Australia/Melbourne" \
      "timezone = Australia/Melbourne" "modules/nixos/locale.nix"
    assert_equals "${check}" "${cfg.i18n.defaultLocale}" "en_GB.UTF-8" \
      "defaultLocale = en_GB.UTF-8" "modules/nixos/locale.nix"
    assert_equals "${check}" "${cfg.i18n.extraLocaleSettings.LC_MONETARY}" "en_AU.UTF-8" \
      "LC_MONETARY = en_AU.UTF-8" "modules/nixos/locale.nix"
    assert_equals "${check}" "${cfg.i18n.extraLocaleSettings.LC_TIME}" "en_AU.UTF-8" \
      "LC_TIME = en_AU.UTF-8" "modules/nixos/locale.nix"
    assert_equals "${check}" "${cfg.console.keyMap}" "us" \
      "console keyMap = us" "modules/nixos/locale.nix"

    # --- Hostname ---
    assert_equals "${check}" "${cfg.networking.hostName}" "p0ch1t4" \
      "hostname = p0ch1t4" "modules/nixos/networking.nix"

    # --- Boot ---
    assert_equals "${check}" "${boolStr cfg.zramSwap.enable}" "true" \
      "zram swap enabled" "modules/nixos/boot.nix"
    assert_equals "${check}" "${toString cfg.zramSwap.memoryPercent}" "50" \
      "zram memoryPercent = 50" "modules/nixos/boot.nix"

    # --- User ---
    assert_equals "${check}" "${boolStr cfg.users.users.michael.isNormalUser}" "true" \
      "michael is a normal user" "modules/nixos/users.nix"
    assert_equals "${check}" "${boolStr (hasGroup "wheel")}" "true" \
      "michael in wheel group" "modules/nixos/users.nix"
    assert_equals "${check}" "${boolStr (hasGroup "video")}" "true" \
      "michael in video group" "modules/nixos/users.nix"
    assert_equals "${check}" "${boolStr (hasGroup "audio")}" "true" \
      "michael in audio group" "modules/nixos/users.nix"
    assert_equals "${check}" "${boolStr (hasGroup "networkmanager")}" "true" \
      "michael in networkmanager group" "modules/nixos/users.nix"
    assert_equals "${check}" "${boolStr cfg.programs.fish.enable}" "true" \
      "fish shell enabled system-wide" "modules/nixos/users.nix"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
