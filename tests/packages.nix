{home-manager}: {
  name = "packages";

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

    # system-level packages
    for cmd in ["fish", "brightnessctl"]:
        machine.succeed(f"which {cmd}")

    # user-level packages (installed via home-manager)
    user_commands = [
        "firefox",
        "wezterm",
        "ghostty",
        "nvim",
        "bat",
        "eza",
        "fzf",
        "zoxide",
        "btop",
        "lazygit",
        "fd",
        "rg",
        "jq",
        "curl",
        "yazi",
        "mpv",
        "zathura",
    ]
    for cmd in user_commands:
        machine.succeed(f"su - michael -c 'which {cmd}'")
  '';
}
