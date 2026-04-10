# Source module → list of test check names to run.
# Agents: after editing a .nix file, look up its path here and run ONLY the listed tests.
# Run unit-* tests first (fast), then integration-* tests (VM-based, slower).
{
  "modules/home/git.nix" = ["unit-git" "integration-packages"];
  "modules/home/shell/fish.nix" = ["unit-shell" "integration-login"];
  "modules/home/shell/cli.nix" = ["unit-cli-tools" "integration-packages"];
  "modules/home/shell/starship.nix" = ["unit-shell"];
  "modules/home/shell/direnv.nix" = ["unit-shell"];
  "modules/home/firefox.nix" = ["unit-firefox" "integration-packages"];
  "modules/home/ssh.nix" = ["unit-ssh" "integration-ssh-hardening"];
  "modules/home/desktop/niri.nix" = ["unit-desktop-niri" "integration-graphical"];
  "modules/home/desktop/waybar.nix" = ["unit-desktop-waybar" "integration-graphical"];
  "modules/home/desktop/mako.nix" = ["unit-desktop-notifications" "integration-graphical"];
  "modules/home/desktop/rofi.nix" = ["unit-desktop-rofi" "integration-graphical"];
  "modules/home/desktop/hyprlock.nix" = ["unit-desktop-lock" "integration-graphical"];
  "modules/home/desktop/hypridle.nix" = ["unit-desktop-lock"];
  "modules/home/desktop/gtk.nix" = ["unit-gtk"];
  "modules/home/terminals/wezterm.nix" = ["unit-terminals" "integration-packages"];
  "modules/home/terminals/wezterm.lua" = ["unit-terminals"];
  "modules/home/terminals/ghostty.nix" = ["unit-terminals" "integration-packages"];
  "modules/home/media.nix" = ["unit-media" "integration-packages"];
  "modules/home/xdg.nix" = ["unit-xdg-mime"];
  "modules/home/apps.nix" = ["integration-packages"];
  "modules/nixos/openssh.nix" = ["unit-nixos-services" "integration-ssh-hardening" "integration-system-services"];
  "modules/nixos/networking.nix" = ["unit-nixos-security" "integration-firewall" "integration-system-services"];
  "modules/nixos/security.nix" = ["unit-nixos-security" "integration-security"];
  "modules/nixos/audio.nix" = ["unit-nixos-services" "integration-system-services"];
  "modules/nixos/bluetooth.nix" = ["unit-nixos-services" "integration-system-services"];
  "modules/nixos/docker.nix" = ["unit-nixos-services"];
  "modules/nixos/locale.nix" = ["unit-nixos-system"];
  "modules/nixos/boot.nix" = ["unit-nixos-system"];
  "modules/nixos/users.nix" = ["unit-nixos-system" "integration-user-config"];
  "modules/nixos/desktop.nix" = ["integration-graphical" "integration-system-services"];
  "theme/tokyonight.nix" = ["unit-theme-propagation" "unit-shell" "unit-cli-tools" "unit-desktop-niri" "unit-desktop-waybar" "unit-desktop-rofi" "unit-media"];
}
