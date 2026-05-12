{
  pkgs,
  colors,
  ...
}: let
  polkitAgent = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
  wallpaper = ../../../assets/wallpapers/evangelion-01.png;

  arrangeOutputs = pkgs.writeShellApplication {
    name = "niri-arrange-outputs";
    runtimeInputs = with pkgs; [niri jq];
    text = builtins.readFile ./niri/arrange-outputs.sh;
  };

  watchOutputs = pkgs.writeShellApplication {
    name = "niri-watch-outputs";
    runtimeInputs = [pkgs.niri arrangeOutputs];
    text = builtins.readFile ./niri/watch-outputs.sh;
  };
in {
  xdg.configFile."niri/config.kdl".text = ''
    // ============================================================
    // Environment & input
    // ============================================================

    environment {
      GTK_THEME "Tokyonight-Dark"
    }

    input {
        keyboard {
            repeat-delay 300
            repeat-rate 30
            numlock
        }
        touchpad {
            tap
            natural-scroll
            scroll-factor 0.5
        }
        workspace-auto-back-and-forth
        focus-follows-mouse max-scroll-amount="95%"
    }

    // ============================================================
    // Outputs
    // ============================================================

    // Output positions are managed at runtime by niri-arrange-outputs
    // (spawn-at-startup below). External monitors stack above eDP-1.
    output "eDP-1" {
        focus-at-startup
        mode "2880x1920@120.000"
        scale 2
        transform "normal"
        variable-refresh-rate on-demand=true
        hot-corners {
          off
        }
    }

    // ============================================================
    // Visuals & behavior
    // ============================================================

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
    }

    cursor {
      xcursor-theme "Bibata-Modern-Classic"
      xcursor-size 20
    }

    animations {
        off
    }

    hotkey-overlay {
        skip-at-startup
        hide-not-bound
    }

    prefer-no-csd
    screenshot-path null

    // ============================================================
    // Window & layer rules
    // ============================================================

    window-rule {
        match app-id="firefox" title="^Picture-in-Picture$"
        open-floating true
    }

    window-rule {
        match app-id="Zotero"
        open-maximized true
    }

    window-rule {
        match app-id="1password"
        block-out-from "screen-capture"
    }

    // ============================================================
    // Startup
    // ============================================================

    // Output arrangement
    spawn-at-startup "${arrangeOutputs}/bin/niri-arrange-outputs"
    spawn-at-startup "${watchOutputs}/bin/niri-watch-outputs"

    // Wallpaper
    spawn-at-startup "awww-daemon"
    spawn-sh-at-startup "sleep 0.5 && awww img ${wallpaper}"

    // Tray & system services
    spawn-at-startup "udiskie" "--no-tray"
    spawn-sh-at-startup "${polkitAgent} &"

    // Desktop shell
    spawn-at-startup "ags-shell"

    // ============================================================
    // Key bindings
    //
    // Order matters: the hotkey overlay (Mod+/) renders binds in
    // the order defined here. Keep related bindings together.
    // ============================================================

    binds {
        // --- Help & session ---
        Mod+Slash          hotkey-overlay-title=null                       { show-hotkey-overlay; }
        Mod+Q repeat=false hotkey-overlay-title="Close Window"             { close-window; }
        Super+X            hotkey-overlay-title="Lock the Screen: hyprlock" { spawn "hyprlock"; }
        Super+Shift+X      hotkey-overlay-title="Logout"                   { quit; }
        Mod+Escape allow-inhibiting=false hotkey-overlay-title=null { toggle-keyboard-shortcuts-inhibit; }

        // --- Applications ---
        Mod+Return       hotkey-overlay-title="Open a Terminal: wezterm"     { spawn "wezterm"; }
        Mod+Shift+Return hotkey-overlay-title="Open a Browser: firefox"      { spawn "firefox"; }
        Mod+E            hotkey-overlay-title="Open a File Browser: dolphin" { spawn "dolphin"; }
        Mod+Space        hotkey-overlay-title="Run an Application: rofi"     { spawn-sh "pkill rofi || rofi -show drun -theme ~/.local/share/rofi/minimal.rasi"; }
        Mod+Shift+C      hotkey-overlay-title="Run a Calculator: rofi"       { spawn-sh "pkill rofi || rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\" -theme ~/.local/share/rofi/minimal.rasi"; }

        // --- Media & brightness ---
        XF86AudioRaiseVolume  allow-when-locked=true hotkey-overlay-title=null { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
        XF86AudioLowerVolume  allow-when-locked=true hotkey-overlay-title=null { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
        XF86AudioMute         allow-when-locked=true hotkey-overlay-title=null { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioPlay         allow-when-locked=true hotkey-overlay-title=null { spawn-sh "playerctl play-pause"; }
        XF86AudioPrev         allow-when-locked=true hotkey-overlay-title=null { spawn-sh "playerctl previous"; }
        XF86AudioNext         allow-when-locked=true hotkey-overlay-title=null { spawn-sh "playerctl next"; }
        XF86MonBrightnessUp   allow-when-locked=true hotkey-overlay-title=null { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
        XF86MonBrightnessDown allow-when-locked=true hotkey-overlay-title=null { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

        // --- Overview ---
        Mod+O repeat=false hotkey-overlay-title="Toggle Overview" { toggle-overview; }

        // --- Arrow-key duplicates (hidden from menu) ---
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Ctrl+Left  { focus-monitor-left; }
        Mod+Ctrl+Down  { focus-monitor-down; }
        Mod+Ctrl+Up    { focus-monitor-up; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

        // --- Focus & move (HJKL + Home/End) ---
        Mod+H hotkey-overlay-title="Focus Column/Window (HJKL)" { focus-column-left; }
        Mod+J hotkey-overlay-title=null { focus-window-or-workspace-down; }
        Mod+K hotkey-overlay-title=null { focus-window-or-workspace-up; }
        Mod+L hotkey-overlay-title=null { focus-column-right; }
        Mod+Shift+H hotkey-overlay-title="Move Column/Window (HJKL)" { move-column-left; }
        Mod+Shift+J hotkey-overlay-title=null { move-window-down-or-to-workspace-down; }
        Mod+Shift+K hotkey-overlay-title=null { move-window-up-or-to-workspace-up; }
        Mod+Shift+L hotkey-overlay-title=null { move-column-right; }
        Mod+Ctrl+H hotkey-overlay-title=null { focus-monitor-left; }
        Mod+Ctrl+J hotkey-overlay-title=null { focus-monitor-down; }
        Mod+Ctrl+K hotkey-overlay-title=null { focus-monitor-up; }
        Mod+Ctrl+L hotkey-overlay-title=null { focus-monitor-right; }
        Mod+Shift+Ctrl+H hotkey-overlay-title=null { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J hotkey-overlay-title=null { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K hotkey-overlay-title=null { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L hotkey-overlay-title=null { move-column-to-monitor-right; }
        Mod+Home       hotkey-overlay-title=null { focus-column-first; }
        Mod+End        hotkey-overlay-title=null { focus-column-last; }
        Mod+Shift+Home hotkey-overlay-title=null { move-column-to-first; }
        Mod+Shift+End  hotkey-overlay-title=null { move-column-to-last; }

        // --- Workspaces ---
        Mod+1 hotkey-overlay-title="Focus Workspace 1-9" { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 hotkey-overlay-title="Move Column to Workspace 1-9" { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Tab             hotkey-overlay-title="Previous Workspace" { focus-workspace-previous; }
        Mod+Shift+Page_Down hotkey-overlay-title=null { move-workspace-down; }
        Mod+Shift+Page_Up   hotkey-overlay-title=null { move-workspace-up; }
        Mod+WheelScrollDown       cooldown-ms=150 hotkey-overlay-title=null { focus-workspace-down; }
        Mod+WheelScrollUp         cooldown-ms=150 hotkey-overlay-title=null { focus-workspace-up; }
        Mod+Shift+WheelScrollDown { focus-column-right; }
        Mod+Shift+WheelScrollUp   { focus-column-left; }

        // --- Column layout ---
        Mod+BracketLeft  hotkey-overlay-title="Consume Window Into Column" { consume-window-into-column; }
        Mod+BracketRight hotkey-overlay-title="Expel Window From Column"   { expel-window-from-column; }
        Mod+R       hotkey-overlay-title="Cycle Preset Column Widths"  { switch-preset-column-width; }
        Mod+F       hotkey-overlay-title="Maximize Column"             { maximize-column; }
        Mod+Shift+F hotkey-overlay-title="Fullscreen Window"           { fullscreen-window; }
        Mod+Ctrl+F  hotkey-overlay-title=null { expand-column-to-available-width; }
        Mod+W       hotkey-overlay-title="Toggle Tabbed Column" { toggle-column-tabbed-display; }
        Mod+C       hotkey-overlay-title=null { center-column; }
        Mod+Ctrl+C  hotkey-overlay-title=null { center-window; }

        // --- Resize (hidden from menu) ---
        Mod+Minus       hotkey-overlay-title=null { set-column-width "-10%"; }
        Mod+Equal       hotkey-overlay-title=null { set-column-width "+10%"; }
        Mod+Shift+Minus hotkey-overlay-title=null { set-window-height "-10%"; }
        Mod+Shift+Equal hotkey-overlay-title=null { set-window-height "+10%"; }
        Mod+Ctrl+R      hotkey-overlay-title=null { reset-window-height; }

        // --- Floating ---
        Mod+T       hotkey-overlay-title="Toggle Window Floating"     { toggle-window-floating; }
        Mod+Shift+T hotkey-overlay-title=null { switch-focus-between-floating-and-tiling; }

        // --- Screenshots ---
        Print           hotkey-overlay-title="Screenshot Region" { screenshot; }
        Mod+Print       hotkey-overlay-title="Screenshot Window" { screenshot-window write-to-disk=false; }
        Mod+Shift+Print hotkey-overlay-title="Screenshot Screen" { screenshot-screen write-to-disk=false; }
    }
  '';

  home.packages = with pkgs; [
    awww
    udiskie
    kdePackages.polkit-kde-agent-1
    networkmanagerapplet
    pavucontrol
    playerctl
    wl-clipboard
    grim
    slurp
    xwayland-satellite
  ];
}
