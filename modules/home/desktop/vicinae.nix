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

      font.normal.family = "0xProto Nerd Font";

      launcher_window.client_side_decorations.enabled = true;

      providers = {
        "browser-extension".enabled = false;

        core.entrypoints = {
          about.enabled = false;
          documentation.enabled = false;
          "list-extensions".enabled = false;
          "manage-fallback".enabled = false;
          "open-config-file".enabled = false;
          "open-default-config".enabled = false;
          "refresh-apps".enabled = true;
          "report-bug".enabled = false;
          sponsor.enabled = false;
          store.enabled = true;
        };

        developer.entrypoints.create.enabled = false;

        "manage-shortcuts".entrypoints = {
          create.enabled = false;
          manage.enabled = false;
        };

        wm.entrypoints."switch-windows".enabled = false;
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
