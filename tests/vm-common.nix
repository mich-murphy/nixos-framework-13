{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../modules/nixos/audio.nix
    ../modules/nixos/bluetooth.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/desktop.nix
    ../modules/nixos/docker.nix
    ../modules/nixos/hardware.nix
    ../modules/nixos/locale.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/openssh.nix
    ../modules/nixos/power.nix
    ../modules/nixos/security.nix
    ../modules/nixos/users.nix
    ../modules/nixos/virtualisation.nix
  ];

  # nix.nix is excluded because the test framework uses read-only nixpkgs.
  # nixpkgs.config and overlays are set at the test pkgs level in flake.nix.
  # Replicate only the nix daemon settings needed for test evaluation.
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["michael"];
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  services.btrfs.autoScrub.enable = lib.mkForce false;

  # Hardware services that don't work in VM
  services.fwupd.enable = lib.mkForce false;

  users.users.michael.initialPassword = lib.mkForce "password";
  users.users.michael.initialHashedPassword = lib.mkForce null;

  # Enable password auth for VM debugging
  services.openssh.settings.PasswordAuthentication = lib.mkForce true;
  services.openssh.openFirewall = lib.mkForce true;

  # greeter needs video group for GPU access
  users.users.greeter.extraGroups = ["video"];

  # nixpkgs.hostPlatform is set by the test framework's read-only nixpkgs
  system.stateVersion = "25.05";

  virtualisation = {
    memorySize = 4096;
    cores = 4;
    graphics = true;
    resolution = {
      x = 1920;
      y = 1080;
    };
    forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
  };
}
