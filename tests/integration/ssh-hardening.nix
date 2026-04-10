{home-manager}: {
  name = "ssh-hardening";

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
            print(f"FAIL [ssh-hardening] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("sshd.service")

    check("sshd PasswordAuthentication=no", "sshd -T | grep -i 'passwordauthentication no'", "modules/nixos/openssh.nix")
    check("sshd PermitRootLogin=no", "sshd -T | grep -i 'permitrootlogin no'", "modules/nixos/openssh.nix")
    check("sshd X11Forwarding=no", "sshd -T | grep -i 'x11forwarding no'", "modules/nixos/openssh.nix")
    check("sshd AllowAgentForwarding=no", "sshd -T | grep -i 'allowagentforwarding no'", "modules/nixos/openssh.nix")

    check("sshd service is active", "systemctl is-active sshd.service", "modules/nixos/openssh.nix")
  '';
}
