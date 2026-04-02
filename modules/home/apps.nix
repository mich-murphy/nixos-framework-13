{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
    zotero
    kdePackages.dolphin
    vlc
    gimp
    owncloud-client
    neovim
  ];
}
