{home-manager}: {
  name = "graphical";

  nodes.machine = {lib, pkgs, ...}: {
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

    # auto-login for graphical testing
    services.greetd.settings.initial_session = {
      command = "niri-session";
      user = "michael";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("greetd.service")

    # wait for niri to start (compositor process)
    machine.wait_until_succeeds("pgrep -u michael niri", timeout=60)

    # niri creates a wayland socket even without full GPU rendering
    machine.wait_until_succeeds(
        "ls /run/user/1000/wayland-* >/dev/null 2>&1",
        timeout=30,
    )

    # niri IPC socket is available
    machine.wait_until_succeeds(
        "ls /run/user/1000/niri.*.sock >/dev/null 2>&1",
        timeout=10,
    )

    # niri spawns startup programs (awww-daemon, udiskie, etc.)
    machine.wait_until_succeeds("pgrep -u michael udiskie", timeout=15)

    # desktop binaries are available on PATH
    for cmd in ["waybar", "rofi", "hyprlock", "mako"]:
        machine.succeed(f"su - michael -c 'which {cmd}'")

    # take a screenshot for human verification (may be blank without GPU)
    machine.screenshot("niri-desktop")
  '';
}
