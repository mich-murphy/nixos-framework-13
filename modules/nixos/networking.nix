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
      trustedInterfaces = ["tailscale0"];
    };
  };

  services = {
    resolved = {
      enable = true;
      settings.Resolve.MulticastDNS = "no";
    };
    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
