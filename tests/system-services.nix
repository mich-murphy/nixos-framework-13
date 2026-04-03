{home-manager}: {
  name = "system-services";

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
    machine.wait_for_unit("greetd.service")
    machine.wait_for_unit("NetworkManager.service")
    machine.wait_for_unit("sshd.service")
    machine.succeed("systemctl is-enabled tailscaled.service")
    machine.succeed("systemctl is-enabled bluetooth.service")
    machine.succeed("systemctl is-enabled avahi-daemon.service")

    # pipewire/wireplumber are NixOS-managed user services installed system-wide
    machine.succeed("test -e /etc/systemd/user/pipewire.service")
    machine.succeed("test -e /etc/systemd/user/pipewire.socket")
    machine.succeed("test -e /etc/systemd/user/wireplumber.service")
  '';
}
