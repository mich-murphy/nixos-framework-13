{pkgs, ...}: {
  home.packages = with pkgs; [
    firefox
    obsidian
    zotero
    kdePackages.dolphin
    vlc
    gimp
    owncloud-client
    neovim
  ];
}
