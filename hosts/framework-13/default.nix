{...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/users.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "25.05";
}
