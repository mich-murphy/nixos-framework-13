{lib, ...}: {
  imports = [
    ../modules/nixos/audio.nix
    ../modules/nixos/bluetooth.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/desktop.nix
    ../modules/nixos/docker.nix
    ../modules/nixos/locale.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/openssh.nix
    ../modules/nixos/security.nix
    ../modules/nixos/users.nix
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

  users.users.michael.initialPassword = lib.mkForce "testpassword";
  users.users.michael.initialHashedPassword = lib.mkForce null;

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
    qemu.options = [
      "-vga virtio"
    ];
  };
}
