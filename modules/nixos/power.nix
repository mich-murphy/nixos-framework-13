{...}: {
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  # Cap charging at 80% for battery longevity. Written via sysfs at boot to
  # bypass the BIOS-level charge-limit bug on AI 300 series, where the
  # firmware setting is ignored after reboot when AC is connected.
  # https://github.com/FrameworkComputer/SoftwareFirmwareIssueTracker/issues/67
  systemd.tmpfiles.rules = [
    "w /sys/class/power_supply/BAT1/charge_control_end_threshold - - - - 80"
  ];

  # No swap device, so the default HybridSleep on critical battery would fail.
  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
  };
}
