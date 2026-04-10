{home-manager}: {
  name = "graphical";

  nodes.machine = {
    lib,
    pkgs,
    ...
  }: {
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

    services.greetd.settings.initial_session = {
      command = "niri-session";
      user = "michael";
    };
  };

  testScript = ''
    def check(desc, cmd, fix_file):
        try:
            machine.succeed(cmd)
            print(f"PASS: {desc}")
        except Exception as e:
            print(f"FAIL [graphical] {desc}")
            print(f"  fix: {fix_file}")
            raise

    def check_wait(desc, cmd, fix_file, timeout=30):
        try:
            machine.wait_until_succeeds(cmd, timeout=timeout)
            print(f"PASS: {desc}")
        except Exception as e:
            print(f"FAIL [graphical] {desc}")
            print(f"  fix: {fix_file}")
            raise

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("greetd.service")

    check_wait("niri process is running", "pgrep -u michael niri", "modules/home/desktop/niri.nix", timeout=60)
    check_wait("wayland socket exists", "ls /run/user/1000/wayland-* >/dev/null 2>&1", "modules/home/desktop/niri.nix", timeout=30)
    check_wait("niri IPC socket exists", "ls /run/user/1000/niri.*.sock >/dev/null 2>&1", "modules/home/desktop/niri.nix", timeout=10)
    check_wait("udiskie is running", "pgrep -u michael udiskie", "modules/home/desktop/niri.nix", timeout=15)

    desktop_binaries = {
        "waybar": "modules/home/desktop/waybar.nix",
        "rofi": "modules/home/desktop/rofi.nix",
        "hyprlock": "modules/home/desktop/hyprlock.nix",
        "mako": "modules/home/desktop/mako.nix",
    }
    for cmd, fix_file in desktop_binaries.items():
        check(f"{cmd} is on PATH", f"su - michael -c 'which {cmd}'", fix_file)

    machine.screenshot("niri-desktop")
  '';
}
