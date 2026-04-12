{home-manager}: {
  name = "boot";

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
            print(f"FAIL [boot] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    # User authentication and shell
    check("michael can authenticate", "echo 'testpassword' | su - michael -c 'whoami' | grep michael", "modules/nixos/users.nix")
    check("home directory works", "su - michael -c 'test -d $HOME'", "modules/nixos/users.nix")
    check("fish shell works", "su - michael -c 'fish -c \"echo hello\"' | grep hello", "modules/home/shell/fish.nix")
    check("EDITOR env var is set", "su - michael -c 'fish -c \"echo \\$EDITOR\"' | grep nvim", "modules/home/default.nix")

    # System services
    check("greetd is running", "systemctl is-active greetd.service", "modules/nixos/desktop.nix")
    check("NetworkManager is running", "systemctl is-active NetworkManager.service", "modules/nixos/networking.nix")
    check("sshd is running", "systemctl is-active sshd.service", "modules/nixos/openssh.nix")
    check("tailscaled is enabled", "systemctl is-enabled tailscaled.service", "modules/nixos/networking.nix")
    check("bluetooth is enabled", "systemctl is-enabled bluetooth.service", "modules/nixos/bluetooth.nix")
    check("avahi-daemon is enabled", "systemctl is-enabled avahi-daemon.service", "modules/nixos/networking.nix")

    # User services (pipewire)
    check("pipewire service exists", "test -e /etc/systemd/user/pipewire.service", "modules/nixos/audio.nix")
    check("wireplumber service exists", "test -e /etc/systemd/user/wireplumber.service", "modules/nixos/audio.nix")
  '';
}
