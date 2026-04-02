{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };
}
