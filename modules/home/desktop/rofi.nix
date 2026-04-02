{
  pkgs,
  colors,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [pkgs.rofi-calc];
  };

  xdg.dataFile."rofi/themes/tokyonight-night.rasi".text = ''
    * {
      bg0:    ${colors.bg};
      bg1:    ${colors.bg1};
      bg2:    ${colors.bg2};
      bg3:    ${colors.bg3};
      bg4:    ${colors.bg4};

      text:   ${colors.fg};

      red:    ${colors.red};
      orange: ${colors.orange};
      yellow: ${colors.yellow};
      green:  ${colors.green};
      aqua:   ${colors.aqua};
      blue:   ${colors.blue};
      purple: ${colors.purple};

      grey0:  ${colors.bg4};
      grey1:  ${colors.fg_dark};
      grey2:  ${colors.fg};
    }
  '';

  xdg.dataFile."rofi/colorscheme.rasi".text = ''
    @theme "~/.local/share/rofi/themes/tokyonight-night.rasi"
  '';

  xdg.dataFile."rofi/minimal.rasi".text = ''
    configuration {
        show-icons:                 false;
        font:                       "JetBrainsMono Nerd Font 9";
    }

    @import "~/.local/share/rofi/colorscheme.rasi"

    * {
        background-color:           transparent;
        text-color:                 @text;
        margin:                     0px;
        padding:                    0px;
        spacing:                    0px;
    }

    window {
        transparency:               "real";
        location:                   center;
        anchor:                     center;
        y-offset:                   0px;
        width:                      500px;
        border:                     3px solid;
        border-radius:              0px;
        border-color:               @purple;
        background-color:           @bg0;
        cursor:                     "default";
    }

    mainbox {
        enabled:                    true;
        spacing:                    15px;
        padding:                    20px;
        background-color:           transparent;
        children:                   [ "inputbar", "listview", "message" ];
    }

    inputbar {
        enabled:                    true;
        spacing:                    10px;
        padding:                    12px 16px;
        border:                     2px solid;
        border-radius:              0px;
        border-color:               @bg3;
        background-color:           @bg0;
        text-color:                 @text;
        children:                   [ "prompt", "entry" ];
    }

    prompt {
        enabled:                    true;
        background-color:           transparent;
        text-color:                 @blue;
    }

    entry {
        enabled:                    true;
        background-color:           transparent;
        text-color:                 @text;
        cursor:                     text;
        placeholder:                "Search...";
        placeholder-color:          @grey1;
    }

    listview {
        enabled:                    true;
        columns:                    1;
        lines:                      9;
        cycle:                      true;
        dynamic:                    true;
        scrollbar:                  false;
        layout:                     vertical;
        reverse:                    false;
        fixed-height:               false;
        fixed-columns:              true;
        spacing:                    8px;
        margin:                     0px;
        padding:                    0px;
        border:                     0px solid;
        border-radius:              0px;
        background-color:           transparent;
        text-color:                 @text;
        cursor:                     "default";
    }

    element {
        enabled:                    true;
        spacing:                    10px;
        padding:                    10px 16px;
        border:                     0px solid;
        border-radius:              0px;
        background-color:           transparent;
        text-color:                 @text;
        cursor:                     pointer;
    }

    element normal.normal {
        background-color:           transparent;
        text-color:                 @text;
    }

    element normal.active {
        background-color:           transparent;
        text-color:                 @green;
    }

    element selected.normal {
        background-color:           @bg2;
        text-color:                 @blue;
    }

    element selected.active {
        background-color:           @bg2;
        text-color:                 @blue;
    }

    element alternate.normal {
        background-color:           transparent;
        text-color:                 @text;
    }

    element alternate.active {
        background-color:           transparent;
        text-color:                 @green;
    }

    element-icon {
        background-color:           transparent;
        text-color:                 inherit;
        size:                       0em;
        cursor:                     inherit;
    }

    element-text {
        background-color:           transparent;
        text-color:                 inherit;
        highlight:                  inherit;
        cursor:                     inherit;
        vertical-align:             0.5;
        horizontal-align:           0.0;
    }

    message {
        enabled:                    true;
        margin:                     0px;
        padding:                    0px;
        border:                     0px solid;
        border-radius:              0px;
        background-color:           transparent;
    }

    textbox {
        padding:                    12px;
        border:                     0px solid;
        border-radius:              0px;
        border-color:               @red;
        background-color:           @red;
        text-color:                 @bg0;
        vertical-align:             0.5;
        horizontal-align:           0.0;
    }

    error-message {
        padding:                    20px;
        border:                     0px solid;
        border-radius:              0px;
        background-color:           @bg0;
        text-color:                 @text;
    }
  '';
}
