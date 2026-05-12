{pkgs, ...}: {
  programs.niri.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.niri = {
      default = ["gnome" "gtk"];
      "org.freedesktop.impl.portal.Screenshot" = "gnome";
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
    };
  };

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
      # Nerd Fonts (monospace with icons)
      nerd-fonts._0xproto
      nerd-fonts.symbols-only
      # Material Symbols (AGS shell icon system)
      material-symbols
      # Noto fonts (Unicode coverage)
      noto-fonts
      noto-fonts-color-emoji
      # Microsoft-compatible fonts
      liberation_ttf
    ];
    fontconfig.defaultFonts = {
      monospace = ["0xProto Nerd Font"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
