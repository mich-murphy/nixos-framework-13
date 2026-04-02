{...}: {
  imports = [
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/cli.nix
    ./shell/direnv.nix
    ./git.nix
    ./terminals/wezterm.nix
    ./terminals/ghostty.nix
    ./desktop/niri.nix
    ./desktop/waybar.nix
    ./desktop/mako.nix
    ./desktop/rofi.nix
    ./desktop/hyprlock.nix
    ./desktop/hypridle.nix
    ./desktop/gtk.nix
    ./firefox.nix
    ./apps.nix
    ./media.nix
    ./ssh.nix
    ./xdg.nix
  ];

  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
