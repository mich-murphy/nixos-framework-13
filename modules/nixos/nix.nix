{...}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = ["https://claude-code.cachix.org"];
      trusted-public-keys = ["claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "/home/michael/nixos#p0ch1t4";
    dates = "Sun 04:40";
    randomizedDelaySec = "2h";
    fixedRandomDelay = true;
    persistent = true;
    allowReboot = false;
    upgrade = false;
    flags = [
      "--no-write-lock-file"
      "--update-input"
      "nixpkgs"
      "--update-input"
      "home-manager"
      "--update-input"
      "nixos-hardware"
      "--update-input"
      "firefox-addons"
      "--update-input"
      "claude-code"
      "--update-input"
      "vicinae"
      "--update-input"
      "tokyonight-nvim"
    ];
  };
}
