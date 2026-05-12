{
  pkgs,
  colors,
  astal-niri,
  ...
}: let
  astal-niri-pkg = import ./ags {inherit pkgs astal-niri;};

  themeScss = pkgs.writeText "_theme.scss" ''
    $bg:        ${colors.bg};
    $bg-dark:   ${colors.bg_dark};
    $bg-alt:    ${colors.bg1};
    $fg:        ${colors.fg};
    $fg-muted:  ${colors.comment};
    $accent:    ${colors.purple};
    $info:      ${colors.blue};
    $warn:      ${colors.yellow};
    $error:     ${colors.red};
    $success:   ${colors.green};
  '';

  agsSrc = pkgs.runCommand "ags-shell-src" {} ''
    cp -r ${./ags/src} $out
    chmod -R u+w $out
    cp ${themeScss} $out/styles/_theme.scss
  '';

  shell = pkgs.ags.bundle {
    pname = "ags-shell";
    version = "0.1.0";
    src = agsSrc;
    entry = "app.ts";
    enableGtk4 = true;
    dependencies =
      [astal-niri-pkg]
      ++ (with pkgs.astal; [
        astal4
        io
        apps
        battery
        bluetooth
        mpris
        network
        notifd
        powerprofiles
        tray
        wireplumber
      ]);
  };
in {
  # dart-sass kept on PATH defensively until step-2 verification confirms the bundle inlines compiled CSS.
  home.packages = [shell pkgs.brightnessctl pkgs.pavucontrol pkgs.blueman pkgs.lm_sensors pkgs.dart-sass];
}
