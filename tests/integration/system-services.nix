{home-manager}: {
  name = "system-services";

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
            print(f"FAIL [system-services] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    check("greetd is running", "systemctl is-active greetd.service", "modules/nixos/desktop.nix")
    check("NetworkManager is running", "systemctl is-active NetworkManager.service", "modules/nixos/networking.nix")
    check("sshd is running", "systemctl is-active sshd.service", "modules/nixos/openssh.nix")
    check("tailscaled is enabled", "systemctl is-enabled tailscaled.service", "modules/nixos/networking.nix")
    check("bluetooth is enabled", "systemctl is-enabled bluetooth.service", "modules/nixos/bluetooth.nix")
    check("avahi-daemon is enabled", "systemctl is-enabled avahi-daemon.service", "modules/nixos/networking.nix")
    check("pipewire service exists", "test -e /etc/systemd/user/pipewire.service", "modules/nixos/audio.nix")
    check("pipewire socket exists", "test -e /etc/systemd/user/pipewire.socket", "modules/nixos/audio.nix")
    check("wireplumber service exists", "test -e /etc/systemd/user/wireplumber.service", "modules/nixos/audio.nix")
  '';
}
