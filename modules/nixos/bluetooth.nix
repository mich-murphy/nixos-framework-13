{
  lib,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.blueman.enable = true;

  systemd.user.services.blueman-applet.serviceConfig.ExecStart =
    lib.mkForce "${pkgs.blueman}/bin/blueman-applet";
}
