{pkgs, ...}: {
  home.packages = [
    pkgs.obsidian
    pkgs.zotero
    pkgs.kdePackages.dolphin
    pkgs.gimp
    # owncloud-client 6.x calls QQuickStyle::setStyle("adwaita-dark"), a style
    # that nixpkgs' Qt 6 build does not ship — emits a QML "module not
    # installed" warning at startup. Force a bundled style instead.
    # Upstream: https://github.com/NixOS/nixpkgs/issues/416914
    (pkgs.owncloud-client.overrideAttrs (old: {
      qtWrapperArgs =
        (old.qtWrapperArgs or [])
        ++ ["--set-default QT_QUICK_CONTROLS_STYLE Basic"];
    }))
  ];
}
