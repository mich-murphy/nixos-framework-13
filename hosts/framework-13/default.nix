{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/keyd.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/users.nix
  ];
  system.stateVersion = "25.05";
}
