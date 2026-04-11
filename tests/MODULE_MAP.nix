# Test mapping for agents.
#
# UNIT TESTS: Run ALL unit tests on ANY .nix file change — they are eval-only and fast.
# INTEGRATION TESTS: Run only the tests mapped to the changed file below.
# If a changed file has no entry, skip integration tests.
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
    "unit-nixos-security"
    "unit-nixos-services"
    "unit-nixos-system"
    "unit-shell"
    "unit-ssh"
    "unit-terminals"
    "unit-theme-propagation"
    "unit-xdg-mime"
  ];

  # Source file → integration tests to run for that file.
  integrationMap = {
    "modules/home/git.nix" = ["integration-packages"];
    "modules/home/shell/fish.nix" = ["integration-login"];
    "modules/home/shell/cli.nix" = ["integration-packages"];
    "modules/home/firefox.nix" = ["integration-packages"];
    "modules/home/ssh.nix" = ["integration-ssh-hardening"];
    "modules/home/desktop/niri.nix" = ["integration-graphical"];
    "modules/home/desktop/waybar.nix" = ["integration-graphical"];
    "modules/home/desktop/mako.nix" = ["integration-graphical"];
    "modules/home/desktop/rofi.nix" = ["integration-graphical"];
    "modules/home/desktop/hyprlock.nix" = ["integration-graphical"];
    "modules/home/terminals/wezterm.nix" = ["integration-packages"];
    "modules/home/terminals/ghostty.nix" = ["integration-packages"];
    "modules/home/media.nix" = ["integration-packages"];
    "modules/home/apps.nix" = ["integration-packages"];
    "modules/nixos/openssh.nix" = ["integration-ssh-hardening" "integration-system-services"];
    "modules/nixos/networking.nix" = ["integration-firewall" "integration-system-services"];
    "modules/nixos/security.nix" = ["integration-security"];
    "modules/nixos/audio.nix" = ["integration-system-services"];
    "modules/nixos/bluetooth.nix" = ["integration-system-services"];
    "modules/nixos/users.nix" = ["integration-user-config"];
    "modules/nixos/desktop.nix" = ["integration-graphical" "integration-system-services"];
  };
}
