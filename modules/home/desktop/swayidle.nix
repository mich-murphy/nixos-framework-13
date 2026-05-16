{...}: {
  services.swayidle = {
    enable = true;

    events = {
      lock = "pidof hyprlock || hyprlock";
      before-sleep = "pidof hyprlock || hyprlock";
      after-resume = "niri msg action power-on-monitors";
    };

    timeouts = [
      {
        timeout = 150;
        command = "brightnessctl -s set 10";
        resumeCommand = "brightnessctl -r";
      }
      {
        timeout = 150;
        command = "brightnessctl -sd rgb:kbd_backlight set 0";
        resumeCommand = "brightnessctl -rd rgb:kbd_backlight";
      }
      {
        timeout = 300;
        command = "pidof hyprlock || hyprlock";
      }
      {
        timeout = 330;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors && brightnessctl -r";
      }
      {
        timeout = 1800;
        command = "systemctl suspend";
      }
    ];
  };
}
