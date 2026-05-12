{colors, ...}: {
  services.mako = {
    enable = false;
    settings = {
      max-visible = 10;
      layer = "top";
      font = "0xProto Nerd Font 10";
      background-color = colors.bg;
      text-color = colors.fg;
      border-color = colors.bg3;
      border-radius = 0;
      max-icon-size = 48;
      default-timeout = 3000;
      anchor = "top-right";
      margin = "0";
    };
  };
}
