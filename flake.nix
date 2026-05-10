{
  description = "NixOS configuration for Framework 13 (AMD Ryzen AI 7 350)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tokyonight-nvim = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    firefox-addons,
    tokyonight-nvim,
    claude-code,
    ...
  }: {
    nixosConfigurations.p0ch1t4 = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          nixpkgs.overlays = [
            firefox-addons.overlays.default
            claude-code.overlays.default
            # Strip `border-spacing` from GTK 3 stylesheets — it's a GTK 4-only
            # property and triggers parser warnings in every GTK 3 app.
            # Upstream: https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme/issues/91
            (_: prev: {
              tokyonight-gtk-theme = prev.tokyonight-gtk-theme.overrideAttrs (old: {
                postInstall =
                  (old.postInstall or "")
                  + ''
                    find "$out/share/themes" -path '*/gtk-3.0/gtk.css' \
                      -exec sed -i '/^[[:space:]]*border-spacing:/d' {} +
                  '';
              });
            })
          ];
          home-manager.extraSpecialArgs = {
            colors = import ./theme/tokyonight.nix;
            inherit tokyonight-nvim;
          };
          home-manager.users.michael = import ./modules/home;
        }
        ./hosts/framework-13
      ];
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
