{
  colors,
  pkgs,
  ...
}: {
  programs.mpv = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      guioptions = "";
      adjust-open = "best-fit";
      scroll-page-aware = true;
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      selection-clipboard = "clipboard";
      notification-error-bg = colors.red;
      notification-error-fg = colors.fg;
      notification-warning-bg = colors.yellow;
      notification-warning-fg = colors.bg3;
      notification-bg = colors.bg;
      notification-fg = colors.fg;
      completion-bg = colors.bg;
      completion-fg = colors.fg_dark;
      completion-group-bg = colors.bg;
      completion-group-fg = colors.fg_dark;
      completion-highlight-bg = colors.bg3;
      completion-highlight-fg = colors.fg;
      index-bg = colors.bg;
      index-fg = colors.fg;
      index-active-bg = colors.bg3;
      index-active-fg = colors.fg;
      inputbar-bg = colors.bg;
      inputbar-fg = colors.fg;
      statusbar-bg = colors.bg;
      statusbar-fg = colors.fg;
      highlight-color = colors.yellow;
      highlight-active-color = colors.green;
      default-bg = colors.bg;
      default-fg = colors.fg;
      render-loading = true;
      render-loading-fg = colors.bg;
      render-loading-bg = colors.fg;
      recolor-lightcolor = colors.bg;
      recolor-darkcolor = colors.fg;
    };
    mappings = {
      K = "zoom in";
      J = "zoom out";
      R = "rotate";
      r = "reload";
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      ffmpegthumbnailer
      imagemagick
      poppler-utils
      mediainfo
      unar
      jq
    ];

    settings = {
      mgr = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      opener = {
        edit = [
          {
            run = ''nvim "$@"'';
            block = true;
          }
        ];
      };
      open.prepend_rules = [
        {
          name = "*.md";
          use = "edit";
        }
      ];
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };

    keymap.mgr.prepend_keymap = [
      {
        on = ["g" "h"];
        run = "cd ~";
        desc = "Go home";
      }
      {
        on = ["g" "c"];
        run = "cd ~/.config";
        desc = "Go to ~/.config";
      }
      {
        on = ["g" "n"];
        run = "cd ~/nixos";
        desc = "Go to ~/nixos";
      }
      {
        on = ["g" "/"];
        run = "cd /";
        desc = "Go to /";
      }
      {
        on = "<C-n>";
        run = ''shell "nvim $0" --block'';
        desc = "Open in nvim";
      }
      {
        on = "<C-g>";
        run = "plugin lazygit";
        desc = "Open lazygit";
      }
      {
        on = "<Enter>";
        run = "plugin smart-enter";
        desc = "Enter or open";
      }
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter or open";
      }
      {
        on = "p";
        run = "plugin smart-paste";
        desc = "Smart paste into hovered dir";
      }
      {
        on = "?";
        run = "help";
        desc = "Show keymap help";
      }
    ];

    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
      smart-paste = pkgs.yaziPlugins.smart-paste;
      lazygit = pkgs.yaziPlugins.lazygit;
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };
    };

    flavors.tokyo-night = pkgs.fetchFromGitHub {
      owner = "BennyOe";
      repo = "tokyo-night.yazi";
      rev = "8e6296f14daff24151c736ebd0b9b6cd89b02b03";
      hash = "sha256-LArhRteD7OQRBguV1n13gb5jkl90sOxShkDzgEf3PA0=";
    };

    theme.flavor.dark = "tokyo-night";
  };
}
