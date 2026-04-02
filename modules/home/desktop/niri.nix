{
  pkgs,
  colors,
  ...
}: let
  polkitAgent = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
in {
  xdg.configFile."niri/config.kdl".text = ''
    environment {
      GTK_THEME "Tokyonight-Dark"
    }

    input {
        keyboard {
            xkb {}
            repeat-delay 300
            repeat-rate 30
            numlock
        }
        touchpad {
            tap
            natural-scroll
            scroll-factor 0.5
        }
        mouse {}
        trackpoint {}
        workspace-auto-back-and-forth
        focus-follows-mouse max-scroll-amount="95%"
    }

    output "DVI-I-1" {
        mode "3440x1440"
        scale 1
        transform "normal"
        position x=0 y=0
        variable-refresh-rate on-demand=true
        hot-corners {
          off
        }
    }

    output "eDP-1" {
        focus-at-startup
        mode "2880x1920@120.000"
        scale 2
        transform "normal"
        position x=960 y=1440
        variable-refresh-rate on-demand=true
        hot-corners {
          off
        }
    }

    layout {
        gaps 5
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 3
            active-color "${colors.aqua}"
            inactive-color "${colors.bg3}"
        }
        border {
            off
        }
        shadow {
            off
        }
        tab-indicator {
          on
          hide-when-single-tab
          place-within-column
          position "right"
          gap -6
          width 3
          length total-proportion=0.3
          corner-radius 15
        }
        struts {}
    }

    hotkey-overlay {
        skip-at-startup
        hide-not-bound
    }

    prefer-no-csd
    screenshot-path null

    animations {
        off
    }

    cursor {
      xcursor-theme "Bibata-Modern-Classic"
      xcursor-size 20
    }

    window-rule {
        match app-id="firefox" title="^Picture-in-Picture$"
        open-floating true
    }

    window-rule {
        match app-id="firefox"
        match app-id="Zotero"
        open-maximized true
    }

    window-rule {
        match app-id="1password"
        block-out-from "screen-capture"
    }

    spawn-at-startup "awww-daemon"
    spawn-at-startup "udiskie"
    spawn-sh-at-startup "${polkitAgent} &"
    spawn-sh-at-startup "nm-applet --indicator"

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+Return       hotkey-overlay-title="Open a Terminal: wezterm"      { spawn "wezterm"; }
        Mod+Shift+Return hotkey-overlay-title="Open a Browser: firefox"       { spawn "firefox"; }
        Mod+E            hotkey-overlay-title="Open a File Browser: dolphin"  { spawn "dolphin"; }
        Mod+Space        hotkey-overlay-title="Run an Application: rofi"      { spawn-sh "pkill rofi || rofi -show drun -theme ~/.local/share/rofi/minimal.rasi"; }
        Mod+C            hotkey-overlay-title="Run a Calculator: rofi"        { spawn-sh "pkill rofi || rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\" -theme ~/.local/share/rofi/minimal.rasi"; }
        Super+X          hotkey-overlay-title="Lock the Screen: hyprlock"     { spawn "hyprlock"; }
        Super+Shift+X    hotkey-overlay-title="Logout"                        { quit; }
        Mod+O repeat=false { toggle-overview; }
        Mod+Q repeat=false { close-window; }

        XF86AudioRaiseVolume  allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
        XF86AudioMute         allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioPlay         allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioPrev         allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext         allow-when-locked=true { spawn-sh "playerctl next"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-or-workspace-down; }
        Mod+K     { focus-window-or-workspace-up; }
        Mod+L     { focus-column-right; }

        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down-or-to-workspace-down; }
        Mod+Shift+K     { move-window-up-or-to-workspace-up; }
        Mod+Shift+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Shift+Home { move-column-to-first; }
        Mod+Shift+End  { move-column-to-last; }

        Mod+Ctrl+Left  { focus-monitor-left; }
        Mod+Ctrl+Down  { focus-monitor-down; }
        Mod+Ctrl+Up    { focus-monitor-up; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Ctrl+H     { focus-monitor-left; }
        Mod+Ctrl+J     { focus-monitor-down; }
        Mod+Ctrl+K     { focus-monitor-up; }
        Mod+Ctrl+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        Mod+Tab { focus-workspace-previous; }

        Mod+BracketLeft  { consume-window-into-column; }
        Mod+BracketRight { expel-window-from-column; }

        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+T       { toggle-window-floating; }
        Mod+Shift+T { switch-focus-between-floating-and-tiling; }

        Mod+W { toggle-column-tabbed-display; }

        Print { screenshot; }
        Mod+Print { screenshot-window write-to-disk=false; }
        Mod+shift+Print { screenshot-screen write-to-disk=false; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
    }
  '';

  home.packages = with pkgs; [
    awww
    udiskie
    kdePackages.polkit-kde-agent-1
    networkmanagerapplet
    pavucontrol
  ];
}
