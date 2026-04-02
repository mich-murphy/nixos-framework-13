{colors, ...}: let
  toHypr = hex: "rgb(${builtins.substring 1 6 hex})";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;

      auth = [
        {
          fingerprint = {
            enabled = true;
            ready_message = "Scan fingerprint to unlock";
            present_message = "Scanning...";
            retry_delay = 250;
          };
        }
      ];

      animations = {
        enabled = true;
        bezier = ["linear, 1, 1, 0, 0"];
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "15%, 5%";
          outline_thickness = 3;
          inner_color = toHypr colors.bg1;
          outer_color = toHypr colors.purple;
          check_color = toHypr colors.green;
          fail_color = toHypr colors.red;
          font_color = toHypr colors.fg;
          fade_on_empty = false;
          rounding = 0;
          font_family = "JetBrainsMono Nerd Font";
          placeholder_text = "Enter password";
          fail_text = "$PAMFAIL";
          dots_spacing = 0.3;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
