{
  pkgs,
  astal-niri-src,
}:
pkgs.callPackage "${astal-niri-src}/lib/niri" {}
