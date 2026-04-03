{home-manager}: {
  name = "user-config";

  nodes.machine = {lib, ...}: {
    imports = [
      ./vm-common.nix
      home-manager.nixosModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.extraSpecialArgs = {
      colors = import ../theme/tokyonight.nix;
    };
    home-manager.users.michael = import ../modules/home;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # user exists
    machine.succeed("id michael")

    # correct groups
    groups = machine.succeed("id -Gn michael")
    for group in ["wheel", "video", "audio", "networkmanager"]:
        assert group in groups, f"michael missing group: {group}, has: {groups}"

    # correct shell
    shell = machine.succeed("getent passwd michael | cut -d: -f7").strip()
    assert "fish" in shell, f"expected fish shell, got: {shell}"

    # home directory exists
    machine.succeed("test -d /home/michael")

    # home-manager profile activated
    machine.succeed("test -d /home/michael/.nix-profile || test -L /home/michael/.nix-profile")
  '';
}
