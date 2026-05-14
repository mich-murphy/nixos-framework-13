{pkgs, ...}: {
  home.packages = [
    pkgs.obsidian
    pkgs.zotero
    pkgs.nautilus
    pkgs.gimp
    # owncloud-client 6.x reads QT_STYLE_OVERRIDE and calls
    # QQuickStyle::setStyle() with it, but adwaita-qt6 ships no
    # QtQuick.Controls 2 module — startup dialog shows
    # "module \"adwaita-dark\" is not installed". setStyle() outranks
    # QT_QUICK_CONTROLS_STYLE, so the only fix is to keep the var out of
    # owncloud's env. Upstream: https://github.com/NixOS/nixpkgs/issues/416914
    (pkgs.owncloud-client.overrideAttrs (old: {
      qtWrapperArgs =
        (old.qtWrapperArgs or [])
        ++ ["--unset QT_STYLE_OVERRIDE"];
    }))
  ];
}
