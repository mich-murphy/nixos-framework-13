{
  pkgs,
  nixpkgs,
  home-manager,
  firefox-addons,
}: let
  eval = nixpkgs.lib.nixosSystem {
    modules = [
      home-manager.nixosModules.home-manager
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        nixpkgs.overlays = [firefox-addons.overlays.default];
        nixpkgs.config.allowUnfree = true;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          colors = import ../../theme/tokyonight.nix;
        };
        home-manager.users.michael = import ../../modules/home;
        system.stateVersion = "25.05";
      }
      ../../modules/nixos/audio.nix
      ../../modules/nixos/bluetooth.nix
      ../../modules/nixos/boot.nix
      ../../modules/nixos/desktop.nix
      ../../modules/nixos/docker.nix
      ../../modules/nixos/locale.nix
      ../../modules/nixos/networking.nix
      ../../modules/nixos/openssh.nix
      ../../modules/nixos/security.nix
      ../../modules/nixos/users.nix
      {
        boot.loader.systemd-boot.enable = pkgs.lib.mkForce false;
        boot.loader.efi.canTouchEfiVariables = pkgs.lib.mkForce false;
        services.btrfs.autoScrub.enable = pkgs.lib.mkForce false;
        fileSystems."/" = {
          device = "/dev/null";
          fsType = "ext4";
        };
        boot.loader.grub.enable = false;
        nix.settings = {
          experimental-features = ["nix-command" "flakes"];
          trusted-users = ["michael"];
        };
      }
    ];
  };
  hmConfig = eval.config.home-manager.users.michael;
in {
  nixosConfig = eval.config;
  homeConfig = hmConfig;
  homeFiles = hmConfig.home.file;
  xdgConfigFiles = hmConfig.xdg.configFile;
  xdgDataFiles = hmConfig.xdg.dataFile;

  assertHelpers = pkgs.writeText "assert-helpers.sh" ''
    assert_contains() {
      local check_name="$1" file="$2" pattern="$3" desc="$4" fix_file="$5"
      if grep -qF "$pattern" "$file"; then
        echo "PASS: $desc"
      else
        echo "FAIL [$check_name] $desc"
        echo "  expected pattern: $pattern"
        echo "  in file: $file"
        echo "  fix: $fix_file"
        exit 1
      fi
    }

    assert_not_contains() {
      local check_name="$1" file="$2" pattern="$3" desc="$4" fix_file="$5"
      if grep -qF "$pattern" "$file"; then
        echo "FAIL [$check_name] $desc"
        echo "  unexpected pattern found: $pattern"
        echo "  in file: $file"
        echo "  fix: $fix_file"
        exit 1
      else
        echo "PASS: $desc"
      fi
    }

    assert_equals() {
      local check_name="$1" actual="$2" expected="$3" desc="$4" fix_file="$5"
      if [ "$actual" = "$expected" ]; then
        echo "PASS: $desc"
      else
        echo "FAIL [$check_name] $desc"
        echo "  expected: $expected"
        echo "  actual:   $actual"
        echo "  fix: $fix_file"
        exit 1
      fi
    }

    assert_file_exists() {
      local check_name="$1" file="$2" desc="$3" fix_file="$4"
      if [ -e "$file" ]; then
        echo "PASS: $desc"
      else
        echo "FAIL [$check_name] $desc"
        echo "  file not found: $file"
        echo "  fix: $fix_file"
        exit 1
      fi
    }
  '';
}
