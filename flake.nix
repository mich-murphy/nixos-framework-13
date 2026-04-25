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
      evalConfig = import ./tests/unit/eval-config.nix {inherit pkgs nixpkgs home-manager firefox-addons;};
    in {
      # Unit tests (fast, no VM)
      unit-shell = import ./tests/unit/shell.nix {inherit pkgs evalConfig;};
      unit-cli-tools = import ./tests/unit/cli-tools.nix {inherit pkgs evalConfig;};
      unit-git = import ./tests/unit/git.nix {inherit pkgs evalConfig;};
      unit-ssh = import ./tests/unit/ssh.nix {inherit pkgs evalConfig;};
      unit-firefox = import ./tests/unit/firefox.nix {inherit pkgs evalConfig;};
      unit-xdg-mime = import ./tests/unit/xdg-mime.nix {inherit pkgs evalConfig;};
      unit-desktop-niri = import ./tests/unit/desktop-niri.nix {inherit pkgs evalConfig;};
      unit-desktop-waybar = import ./tests/unit/desktop-waybar.nix {inherit pkgs evalConfig;};
      unit-desktop-notifications = import ./tests/unit/desktop-notifications.nix {inherit pkgs evalConfig;};
      unit-desktop-rofi = import ./tests/unit/desktop-rofi.nix {inherit pkgs evalConfig;};
      unit-desktop-lock = import ./tests/unit/desktop-lock.nix {inherit pkgs evalConfig;};
      unit-terminals = import ./tests/unit/terminals.nix {inherit pkgs evalConfig;};
      unit-media = import ./tests/unit/media.nix {inherit pkgs evalConfig;};
      unit-gtk = import ./tests/unit/gtk.nix {inherit pkgs evalConfig;};
      unit-theme-propagation = import ./tests/unit/theme-propagation.nix {inherit pkgs evalConfig;};
      unit-nixos-services = import ./tests/unit/nixos-services.nix {inherit pkgs evalConfig;};
      unit-nixos-security = import ./tests/unit/nixos-security.nix {inherit pkgs evalConfig;};
      unit-nixos-system = import ./tests/unit/nixos-system.nix {inherit pkgs evalConfig;};
      unit-nixos-hardware = import ./tests/unit/nixos-hardware.nix {inherit pkgs evalConfig;};
      unit-nixos-power = import ./tests/unit/nixos-power.nix {inherit pkgs evalConfig;};
      unit-nixos-virtualisation = import ./tests/unit/nixos-virtualisation.nix {inherit pkgs evalConfig;};
      unit-home-apps = import ./tests/unit/home-apps.nix {inherit pkgs evalConfig;};
      unit-home-direnv = import ./tests/unit/home-direnv.nix {inherit pkgs evalConfig;};

      # Integration tests (VM-based, runtime behavior only)
      integration-boot = pkgs.testers.runNixOSTest (import ./tests/integration/boot.nix {inherit home-manager;});
      integration-graphical = pkgs.testers.runNixOSTest (import ./tests/integration/graphical.nix {inherit home-manager;});
      integration-user-config = pkgs.testers.runNixOSTest (import ./tests/integration/user-config.nix {inherit home-manager;});
      integration-home-manager-files = pkgs.testers.runNixOSTest (import ./tests/integration/home-manager-files.nix {inherit home-manager;});
    };

    nixosConfigurations.user-test-vm = nixpkgs.lib.nixosSystem {
      modules = [
        (import ./tests/interactive-vm.nix {inherit home-manager firefox-addons;})
      ];
    };

    packages.x86_64-linux.user-test-vm =
      self.nixosConfigurations.user-test-vm.config.system.build.vm;

    apps.x86_64-linux.user-test-vm = let
      vmHostName = self.nixosConfigurations.user-test-vm.config.networking.hostName;
    in {
      type = "app";
      program = "${self.packages.x86_64-linux.user-test-vm}/bin/run-${vmHostName}-vm";
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
