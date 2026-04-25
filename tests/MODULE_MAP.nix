# Test mapping for agents.
#
# UNIT TESTS: Run ALL unit tests on ANY .nix file change — they are eval-only and fast.
# INTEGRATION TESTS: Run only the tests mapped to the changed file below.
# If a changed file has no entry, skip integration tests.
#
# Integration tests verify RUNTIME BEHAVIOR only (process startup, service activation).
# Config correctness is tested by unit tests.
{
  # All unit test check names. Run every one of these on any change.
  unitTests = [
    "unit-cli-tools"
    "unit-desktop-lock"
    "unit-desktop-niri"
    "unit-desktop-notifications"
    "unit-desktop-rofi"
    "unit-desktop-waybar"
    "unit-firefox"
    "unit-git"
    "unit-gtk"
    "unit-media"
    "unit-nixos-hardware"
    "unit-nixos-security"
    "unit-nixos-services"
    "unit-nixos-system"
    "unit-nixos-power"
    "unit-nixos-virtualisation"
    "unit-home-apps"
    "unit-home-direnv"
    "unit-shell"
    "unit-ssh"
    "unit-terminals"
    "unit-theme-propagation"
    "unit-xdg-mime"
  ];

  # Source file → integration tests to run for that file.
  # Only 4 integration tests remain (runtime behavior verification):
  #   - integration-boot: user auth, shell, system services
  #   - integration-graphical: desktop process startup
  #   - integration-user-config: user/group verification
  #   - integration-home-manager-files: config file content
  integrationMap = {
    "modules/home/shell/fish.nix" = ["integration-boot"];
    "modules/home/desktop/niri.nix" = ["integration-graphical"];
    "modules/home/desktop/waybar.nix" = ["integration-graphical"];
    "modules/home/desktop/mako.nix" = ["integration-graphical"];
    "modules/home/desktop/rofi.nix" = ["integration-graphical"];
    "modules/home/desktop/hyprlock.nix" = ["integration-graphical"];
    "modules/nixos/openssh.nix" = ["integration-boot"];
    "modules/nixos/networking.nix" = ["integration-boot"];
    "modules/nixos/audio.nix" = ["integration-boot"];
    "modules/nixos/bluetooth.nix" = ["integration-boot"];
    "modules/nixos/hardware.nix" = ["integration-boot"];
    "modules/nixos/users.nix" = ["integration-boot" "integration-user-config"];
    "modules/nixos/desktop.nix" = ["integration-boot" "integration-graphical"];
    "modules/nixos/docker.nix" = ["integration-boot"];
    "modules/nixos/virtualisation.nix" = ["integration-boot"];
    "modules/nixos/power.nix" = [];
    "modules/home/apps.nix" = [];
    "modules/home/shell/direnv.nix" = [];
    "modules/home/default.nix" = ["integration-home-manager-files"];
  };
}
