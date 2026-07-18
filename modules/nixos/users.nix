{pkgs, ...}: {
  users.users.michael = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager"];
    initialHashedPassword = "$6$PnLxwTmzu0wKOBsQ$X.r/LW45BuctJ7VS5Cq0llY8kK1gKQyt02tn4CvP66bkvTKtK.OvXf1W5351Td9t88/xD01bfURPLjIRsptpD1";
  };

  # System-level: registers fish as a valid login shell and loads vendor completions from system pkgs.
  programs.fish.enable = true;
}
