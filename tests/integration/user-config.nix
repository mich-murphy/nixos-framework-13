{home-manager}: {
  name = "user-config";

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
            print(f"FAIL [user-config] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    check("user michael exists", "id michael", "modules/nixos/users.nix")

    groups = machine.succeed("id -Gn michael")
    for group in ["wheel", "video", "audio", "networkmanager"]:
        if group in groups:
            print(f"PASS: michael in group {group}")
        else:
            print(f"FAIL [user-config] michael missing group: {group}")
            print(f"  fix: modules/nixos/users.nix")
            raise AssertionError(f"michael missing group: {group}, has: {groups}")

    check("shell is fish", "getent passwd michael | cut -d: -f7 | grep fish", "modules/nixos/users.nix")
    check("home directory exists", "test -d /home/michael", "modules/nixos/users.nix")
    check("home-manager profile activated", "test -d /home/michael/.nix-profile || test -L /home/michael/.nix-profile", "modules/home/default.nix")
  '';
}
