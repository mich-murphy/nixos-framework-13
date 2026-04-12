{pkgs, ...}: {
  programs.niri.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

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
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.meslo-lg
      # Noto fonts (Unicode coverage)
      noto-fonts
      noto-fonts-color-emoji
      # Microsoft-compatible fonts
      liberation_ttf
    ];
    fontconfig.defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
