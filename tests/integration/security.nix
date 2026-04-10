{home-manager}: {
  name = "security";

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
            print(f"FAIL [security] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")

    check("BPF disabled for unprivileged", "sysctl -n kernel.unprivileged_bpf_disabled | grep -q 1", "modules/nixos/security.nix")
    check("BPF JIT hardened", "sysctl -n net.core.bpf_jit_harden | grep -q 2", "modules/nixos/security.nix")

    check("sudo requires wheel group", "grep -q 'wheel' /etc/sudoers || grep -rq 'wheel' /etc/sudoers.d/", "modules/nixos/security.nix")
  '';
}
