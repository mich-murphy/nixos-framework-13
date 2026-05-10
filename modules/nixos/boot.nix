{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    tmp.cleanOnBoot = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
