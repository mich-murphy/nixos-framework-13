{pkgs, ...}: {
  users.users.michael = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
    initialHashedPassword = "$6$PnLxwTmzu0wKOBsQ$X.r/LW45BuctJ7VS5Cq0llY8kK1gKQyt02tn4CvP66bkvTKtK.OvXf1W5351Td9t88/xD01bfURPLjIRsptpD1";
  };

  programs.fish.enable = true;
}
