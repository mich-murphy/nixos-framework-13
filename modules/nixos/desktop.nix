{pkgs, ...}: {
  programs.niri.enable = true;
  programs.dconf.enable = true;

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
    packages = builtins.attrValues {
      # Nerd Fonts (monospace with icons)
      inherit (pkgs.nerd-fonts) _0xproto symbols-only;
      # Noto fonts (Unicode coverage)
      inherit (pkgs) noto-fonts noto-fonts-color-emoji;
      # Microsoft-compatible fonts
      inherit (pkgs) liberation_ttf;
    };
    fontconfig.defaultFonts = {
      monospace = ["0xProto Nerd Font"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment.systemPackages = [pkgs.brightnessctl];
}
