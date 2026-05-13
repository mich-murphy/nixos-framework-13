{
  pkgs,
  colors,
  ags,
  astal-niri,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;

  astalNiri = astal-niri.packages.${system};
  astalDeps = with astalNiri; [
    niri
    battery
    bluetooth
    mpris
    network
    notifd
    powerprofiles
    tray
    wireplumber
  ];

  agsWithDeps = ags.packages.${system}.default.override {
    extraPackages = astalDeps;
  };

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

  shell = pkgs.stdenv.mkDerivation {
    pname = "ags-shell";
    version = "0.1.0";
    src = agsSrc;

    nativeBuildInputs = [
      pkgs.wrapGAppsHook4
      pkgs.gobject-introspection
      agsWithDeps
    ];

    buildInputs =
      astalDeps
      ++ [
        pkgs.gjs
        pkgs.libadwaita
        pkgs.libsoup_3
      ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      cp -r * $out/share
      ags bundle --gtk 4 "$out/share/app.ts" "$out/bin/ags-shell" -d "SRC='$out/share'"
      runHook postInstall
    '';
  };
in {
  home.packages = [
    shell
    pkgs.brightnessctl
    pkgs.pavucontrol
    pkgs.blueman
    pkgs.lm_sensors
  ];
}
