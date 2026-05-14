{
  pkgs,
  colors,
  vicinae,
  ...
}: {
  imports = [vicinae.homeManagerModules.default];

  services.vicinae = {
    enable = true;
    package = pkgs.vicinae;
    systemd.enable = true;

    settings = {
      theme = {
        dark.name = "tokyonight";
        light.name = "tokyonight";
      };
    };

    themes.tokyonight = {
      meta = {
        name = "Tokyo Night";
        description = "Tokyo Night palette";
        variant = "dark";
        inherits = "vicinae-dark";
      };

      colors = {
        core = {
          background = colors.bg;
          foreground = colors.fg;
          secondary_background = colors.bg_dark;
          border = colors.bg3;
          accent = colors.purple;
          accent_foreground = colors.bg;
        };

        accents = {
          blue = colors.blue;
          green = colors.green;
          magenta = colors.magenta;
          orange = colors.orange;
          purple = colors.purple;
          red = colors.red;
          yellow = colors.yellow;
          cyan = colors.cyan;
        };
      };
    };
  };
}
