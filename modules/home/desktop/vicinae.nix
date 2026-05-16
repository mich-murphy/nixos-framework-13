{
  pkgs,
  colors,
  vicinae,
  ...
}: {
  imports = [vicinae.homeManagerModules.default];

  xdg.dataFile."vicinae/scripts/keep-awake.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      # @vicinae.schemaVersion 1
      # @vicinae.title Toggle Keep Awake
      # @vicinae.description Inhibit screen idle and lock timers until toggled off
      # @vicinae.mode silent
      # @vicinae.icon ☕
      # @vicinae.exec ["${pkgs.bash}/bin/bash"]

      set -u
      pidfile="''${XDG_RUNTIME_DIR:-/tmp}/vicinae-keep-awake.pid"
      notify=${pkgs.libnotify}/bin/notify-send

      if [ -f "$pidfile" ] && pid=$(cat "$pidfile") && kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        rm -f "$pidfile"
        "$notify" -a "Keep Awake" -i system-suspend "Keep awake: off" "Idle and lock timers restored."
      else
        rm -f "$pidfile"
        ${pkgs.systemd}/bin/systemd-inhibit \
          --what=idle \
          --who=Vicinae \
          --why="Keep awake toggle" \
          --mode=block \
          ${pkgs.coreutils}/bin/sleep infinity </dev/null >/dev/null 2>&1 &
        echo $! > "$pidfile"
        disown
        "$notify" -a "Keep Awake" -i system-run "Keep awake: on" "Screen will stay awake until toggled off."
      fi
    '';
  };

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
