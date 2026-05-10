{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
    zotero
    kdePackages.dolphin
    gimp
    owncloud-client
  ];
}
