{colors, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      scan_timeout = 10;
      palette = "tokyonight";
      palettes.tokyonight = {
        inherit (colors) red orange yellow green aqua teal cyan blue purple magenta fg bg comment;
      };
      git_status.deleted = "";
      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        unknown_symbol = "󰂑 ";
        empty_symbol = "󰂎 ";
        format = "[$symbol$percentage]($style) ";
        display = [
          {
            threshold = 20;
            style = "bold red";
          }
          {
            threshold = 30;
            style = "bold orange";
          }
        ];
      };
      nix_shell = {
        symbol = "󱄅 ";
        style = "bold blue";
        heuristic = true;
        format = "via [$symbol$state( \\($name\\))]($style) ";
      };
      direnv = {
        disabled = false;
        style = "bold orange";
      };
    };
  };
}
