{
  home-manager,
  firefox-addons,
}: {
  modulesPath,
  lib,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
    ./vm-common.nix
    home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [firefox-addons.overlays.default];
  home-manager.extraSpecialArgs = {
    colors = import ../theme/tokyonight.nix;
  };
  home-manager.users.michael = import ../modules/home;

  virtualisation.diskSize = 8192;
  virtualisation.sharedDirectories.host-shared = {
    source = "$HOME/shared-vm";
    target = "/mnt/shared";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
