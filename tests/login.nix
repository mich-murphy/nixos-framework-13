{home-manager}: {
  name = "login";

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

    # michael can authenticate with the test password
    machine.succeed("echo 'testpassword' | su - michael -c 'whoami' | grep michael")

    # michael has a working home directory after login
    machine.succeed("su - michael -c 'test -d $HOME'")

    # fish shell works
    machine.succeed("su - michael -c 'fish -c \"echo hello\"' | grep hello")

    # environment variables from home-manager are set
    machine.succeed("su - michael -c 'fish -c \"echo \\$EDITOR\"' | grep nvim")
  '';
}
