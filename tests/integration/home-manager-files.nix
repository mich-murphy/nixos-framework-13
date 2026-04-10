{home-manager}: {
  name = "home-manager-files";

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
        except Exception:
            print(f"FAIL [home-manager-files] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    files = {
        ".config/git/config": "modules/home/git.nix",
        ".config/niri/config.kdl": "modules/home/desktop/niri.nix",
        ".config/fish/themes/tokyonight_night.theme": "modules/home/shell/fish.nix",
        ".config/btop/themes/tokyonight.theme": "modules/home/shell/cli.nix",
        ".config/yazi/theme.toml": "modules/home/media.nix",
    }
    for path, fix in files.items():
        check(f"{path} exists", f"test -e /home/michael/{path}", fix)

    check("git config has user.name", "grep -q 'Michael Murphy' /home/michael/.config/git/config", "modules/home/git.nix")
    check("fish theme has fg color", "grep -q 'c0caf5' /home/michael/.config/fish/themes/tokyonight_night.theme", "modules/home/shell/fish.nix")
    check("niri config has Tokyo Night theme", "grep -q 'Tokyonight-Dark' /home/michael/.config/niri/config.kdl", "modules/home/desktop/niri.nix")
  '';
}
