{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };

      "*" = {
        AddKeysToAgent = "yes";
        HashKnownHosts = true;
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        IdentitiesOnly = true;
        ForwardAgent = false;
        ForwardX11 = false;
        ForwardX11Trusted = false;
      };
    };
  };
}
