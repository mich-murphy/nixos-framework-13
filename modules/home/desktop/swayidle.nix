{
  pkgs,
  lib,
  ...
}: let
  hyprlock = lib.getExe pkgs.hyprlock;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  niri = lib.getExe pkgs.niri;
  pgrep = lib.getExe' pkgs.procps "pgrep";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  lockCmd = "${pgrep} -x hyprlock || ${hyprlock}";
in {
  services.swayidle = {
    enable = true;

    events = {
      lock = lockCmd;
      before-sleep = lockCmd;
      after-resume = "${niri} msg action power-on-monitors";
    };

    timeouts = [
      {
        timeout = 150;
        command = "${brightnessctl} -s set 10";
        resumeCommand = "${brightnessctl} -r";
      }
      {
        timeout = 150;
        command = "${brightnessctl} -sd rgb:kbd_backlight set 0";
        resumeCommand = "${brightnessctl} -rd rgb:kbd_backlight";
      }
      {
        timeout = 300;
        command = lockCmd;
      }
      {
        timeout = 330;
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors && ${brightnessctl} -r";
      }
      {
        timeout = 1800;
        command = "${systemctl} suspend";
      }
    ];
  };
}
