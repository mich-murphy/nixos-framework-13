{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraOptionOverrides = {
      AddKeysToAgent = "confirm";
      HostKeyAlgorithms = "ssh-ed25519-cert-v01@openssh.com,ssh-ed25519";
      KexAlgorithms = "sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org";
      Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com";
      MACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com";
      VisualHostKey = "yes";
    };

    matchBlocks."*" = {
      hashKnownHosts = true;
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      controlMaster = "auto";
      controlPath = "~/.ssh/sockets/%r@%h-%p";
      controlPersist = "10m";
      identitiesOnly = true;
      forwardAgent = false;
      forwardX11 = false;
      forwardX11Trusted = false;
    };
  };
}
