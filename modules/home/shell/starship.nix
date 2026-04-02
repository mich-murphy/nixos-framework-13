{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      scan_timeout = 10;
      git_status.deleted = "";
    };
  };
}
