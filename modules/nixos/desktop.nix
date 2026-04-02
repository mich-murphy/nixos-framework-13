{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  security.pam.services.hyprlock = {};

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["michael"];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.meslo-lg
    ];
    fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font"];
  };

  environment.systemPackages = with pkgs; [
    niri
    brightnessctl
    playerctl
    wl-clipboard
    grim
    slurp
    xwayland-satellite
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    config.common.default = "*";
  };

  security.polkit.enable = true;
}
