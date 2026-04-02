{colors, ...}: {
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
      sandbox = "none";
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
  };

  xdg.configFile."yazi/theme.toml".text = ''
    [mgr]
    cwd = { fg = "${colors.fg_dark}", italic = true }

    hovered         = { bg = "${colors.bg1}" }
    preview_hovered = { bg = "${colors.bg1}" }

    find_keyword  = { fg = "${colors.bg_dark}", bg = "${colors.orange}", bold = true }
    find_position = { fg = "${colors.blue2}", bg = "#192b38", bold = true }

    marker_copied   = { fg = "${colors.green}", bg = "${colors.green}" }
    marker_cut      = { fg = "${colors.red}", bg = "${colors.red}" }
    marker_marked   = { fg = "${colors.purple}", bg = "${colors.purple}" }
    marker_selected = { fg = "${colors.blue}", bg = "${colors.blue}" }

    count_copied   = { fg = "${colors.bg_dark}", bg = "${colors.green}" }
    count_cut      = { fg = "${colors.bg_dark}", bg = "${colors.red}" }
    count_selected = { fg = "${colors.bg_dark}", bg = "${colors.blue}" }

    border_symbol = "│"
    border_style  = { fg = "${colors.teal}" }

    [tabs]
    active   = { fg = "${colors.bg_dark}", bg = "${colors.blue}" }
    inactive = { fg = "${colors.blue}", bg = "${colors.fg_gutter}" }

    [mode]
    normal_main = { fg = "${colors.bg_dark}", bg = "${colors.blue}", bold = true }
    normal_alt  = { fg = "${colors.blue}", bg = "${colors.fg_gutter}" }

    select_main = { fg = "${colors.bg_dark}", bg = "${colors.purple}", bold = true }
    select_alt  = { fg = "${colors.purple}", bg = "${colors.fg_gutter}" }

    unset_main  = { fg = "${colors.bg_dark}", bg = "${colors.purple0}", bold = true }
    unset_alt   = { fg = "${colors.purple0}", bg = "${colors.fg_gutter}" }

    [status]
    overall   = { fg = "${colors.fg}", bg = "${colors.bg_dark}" }
    sep_left  = { open = "", close = "" }
    sep_right = { open = "", close = "" }

    progress_label  = { fg = "${colors.fg}", bold = true }
    progress_normal = { fg = "${colors.blue0}", bg = "${colors.bg1}" }
    progress_error  = { fg = "${colors.red1}", bg = "${colors.bg1}" }

    perm_type  = { fg = "${colors.blue}" }
    perm_read  = { fg = "${colors.yellow}" }
    perm_write = { fg = "${colors.red}" }
    perm_exec  = { fg = "${colors.green}" }
    perm_sep   = { fg = "${colors.bg3}" }

    [pick]
    border   = { fg = "${colors.teal}" }
    active   = { fg = "${colors.fg}",  bg = "${colors.bg2}" }
    inactive = { fg = "${colors.fg}" }

    [input]
    border   = { fg = "${colors.blue2}" }
    title    = { fg = "${colors.blue2}" }
    value    = { fg = "${colors.purple0}" }
    selected = { bg = "${colors.bg2}" }

    [cmp]
    border   = { fg = "${colors.blue2}" }
    active   = { fg = "${colors.fg}", bg = "#343a55" }
    inactive = { fg = "${colors.fg}" }

    icon_file    = ""
    icon_folder  = ""
    icon_command = ""

    [tasks]
    border  = { fg = "${colors.teal}" }
    title   = { fg = "${colors.teal}" }
    hovered = { fg = "${colors.fg}", bg = "${colors.bg2}" }

    [which]
    cols            = 3
    mask            = { bg = "${colors.bg_dark}" }
    cand            = { fg = "${colors.aqua}" }
    rest            = { fg = "${colors.blue}" }
    desc            = { fg = "${colors.purple}" }
    separator       = " ➜ "
    separator_style = { fg = "${colors.comment}" }

    [confirm]
    border  = { fg = "${colors.blue2}" }
    title   = { fg = "${colors.teal}" }
    content = {}
    list    = {}
    btn_yes = { bg = "${colors.bg2}" }
    btn_no  = {}
    btn_labels = [ "  [Y]es  ", "  (N)o  " ]

    [spot]
    border  = { fg = "${colors.teal}" }
    title   = { fg = "${colors.teal}" }

    [notify]
    title_info  = { fg = "${colors.blue2}" }
    title_warn  = { fg = "${colors.yellow}" }
    title_error = { fg = "${colors.red1}" }

    icon_error = ""
    icon_warn = ""
    icon_info = ""

    [help]
    on      = { fg = "${colors.green}" }
    run     = { fg = "${colors.purple}" }
    desc    = { fg = "${colors.aqua}" }
    hovered = { bg = "${colors.bg1}" }
    footer  = { fg = "${colors.fg}", bg = "${colors.bg}" }

    [filetype]

    rules = [
    	{ mime = "image/*", fg = "${colors.yellow}" },
    	{ mime = "{audio,video}/*", fg = "${colors.purple}" },
    	{ mime = "application/*zip", fg = "${colors.red}" },
    	{ mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", fg = "${colors.red}" },
    	{ mime = "application/{pdf,doc,rtf,vnd.*}", fg = "${colors.aqua}" },
    	{ name = "*", is = "orphan", bg = "${colors.red}" },
    	{ name = "*", is = "exec"  , fg = "${colors.green}" },
    	{ name = "*/", fg = "${colors.blue}" },
    	{ name = "*", fg = "${colors.fg}" }
    ]
  '';
}
