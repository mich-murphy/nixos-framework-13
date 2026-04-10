{home-manager}: {
  name = "packages";

  nodes.machine = {lib, ...}: {
    imports = [
      ../vm-common.nix
      home-manager.nixosModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.extraSpecialArgs = {
      colors = import ../../theme/tokyonight.nix;
    };
    home-manager.users.michael = import ../../modules/home;
  };

  testScript = ''
    def check(desc, cmd, fix_file):
        try:
            machine.succeed(cmd)
            print(f"PASS: {desc}")
        except Exception as e:
            print(f"FAIL [packages] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    check("fish is installed (system)", "which fish", "modules/nixos/desktop.nix")
    check("brightnessctl is installed (system)", "which brightnessctl", "modules/nixos/desktop.nix")

    user_packages = {
        "firefox": "modules/home/firefox.nix",
        "wezterm": "modules/home/terminals/wezterm.nix",
        "ghostty": "modules/home/terminals/ghostty.nix",
        "nvim": "modules/home/apps.nix",
        "bat": "modules/home/shell/cli.nix",
        "eza": "modules/home/shell/cli.nix",
        "fzf": "modules/home/shell/cli.nix",
        "zoxide": "modules/home/shell/cli.nix",
        "btop": "modules/home/shell/cli.nix",
        "lazygit": "modules/home/shell/cli.nix",
        "fd": "modules/home/shell/cli.nix",
        "rg": "modules/home/shell/cli.nix",
        "jq": "modules/home/shell/cli.nix",
        "curl": "modules/home/shell/cli.nix",
        "yazi": "modules/home/media.nix",
        "mpv": "modules/home/media.nix",
        "zathura": "modules/home/media.nix",
    }
    for cmd, fix_file in user_packages.items():
        check(f"{cmd} is installed (user)", f"su - michael -c 'which {cmd}'", fix_file)
  '';
}
