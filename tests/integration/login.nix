{home-manager}: {
  name = "login";

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
            print(f"FAIL [login] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    check("michael can authenticate", "echo 'testpassword' | su - michael -c 'whoami' | grep michael", "modules/nixos/users.nix")
    check("home directory works", "su - michael -c 'test -d $HOME'", "modules/nixos/users.nix")
    check("fish shell works", "su - michael -c 'fish -c \"echo hello\"' | grep hello", "modules/home/shell/fish.nix")
    check("EDITOR env var is set", "su - michael -c 'fish -c \"echo \\$EDITOR\"' | grep nvim", "modules/home/default.nix")
  '';
}
