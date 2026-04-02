{...}: {
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=AU
  '';

  networking = {
    hostName = "p0ch1t4";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      trustedInterfaces = ["tailscale0"];
    };
  };

  services = {
    resolved.enable = true;
    tailscale = {
      enable = true;
      openFirewall = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = false;
    };
  };
}
