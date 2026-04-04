{
  description = "NixOS configuration for Framework 13 (AMD Ryzen AI 7 350)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nixos-hardware,
    firefox-addons,
    ...
  }: {
    nixosConfigurations.p0ch1t4 = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          nixpkgs.overlays = [firefox-addons.overlays.default];
          home-manager.extraSpecialArgs = {
            colors = import ./theme/tokyonight.nix;
          };
          home-manager.users.michael = import ./modules/home;
        }
        ./hosts/framework-13
      ];
    };

    checks.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [firefox-addons.overlays.default];
      };
    in {
      system-services = pkgs.testers.runNixOSTest (import ./tests/system-services.nix {inherit home-manager;});
      user-config = pkgs.testers.runNixOSTest (import ./tests/user-config.nix {inherit home-manager;});
      packages = pkgs.testers.runNixOSTest (import ./tests/packages.nix {inherit home-manager;});
      graphical = pkgs.testers.runNixOSTest (import ./tests/graphical.nix {inherit home-manager;});
      login = pkgs.testers.runNixOSTest (import ./tests/login.nix {inherit home-manager;});
    };

    nixosConfigurations.user-test-vm = nixpkgs.lib.nixosSystem {
      modules = [
        (import ./tests/interactive-vm.nix {inherit home-manager firefox-addons;})
      ];
    };

    packages.x86_64-linux.user-test-vm =
      self.nixosConfigurations.user-test-vm.config.system.build.vm;

    apps.x86_64-linux.user-test-vm = {
      type = "app";
      program = "${self.packages.x86_64-linux.user-test-vm}/bin/run-nixos-vm";
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
