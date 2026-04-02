{
  pkgs,
  colors,
  ...
}: {
  programs.bat = {
    enable = true;
    config.theme = "tokyonight_night";
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    extraOptions = ["--group-directories-first" "-la"];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    defaultOptions = [
      "--highlight-line"
      "--info=inline-right"
      "--ansi"
      "--layout=reverse"
      "--border=none"
      "--color=bg+:${colors.bg2}"
      "--color=bg:${colors.bg_dark}"
      "--color=border:${colors.teal}"
      "--color=fg:${colors.fg}"
      "--color=gutter:${colors.bg_dark}"
      "--color=header:${colors.orange}"
      "--color=hl+:${colors.cyan}"
      "--color=hl:${colors.cyan}"
      "--color=info:${colors.bg4}"
      "--color=marker:${colors.magenta}"
      "--color=pointer:${colors.magenta}"
      "--color=prompt:${colors.cyan}"
      "--color=query:${colors.fg}:regular"
      "--color=scrollbar:${colors.teal}"
      "--color=separator:${colors.orange}"
      "--color=spinner:${colors.magenta}"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyonight";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.tealdeer = {
    enable = true;
    settings.display.compact = true;
  };

  programs.lazygit = {
    enable = true;
    settings.gui = {
      nerdFontsVersion = "3";
      theme = {
        activeBorderColor = ["${colors.orange}" "bold"];
        inactiveBorderColor = ["${colors.teal}"];
        searchingActiveBorderColor = ["${colors.orange}" "bold"];
        optionsTextColor = ["${colors.blue}"];
        selectedLineBgColor = ["${colors.bg2}"];
        cherryPickedCommitFgColor = ["${colors.blue}"];
        cherryPickedCommitBgColor = ["${colors.purple}"];
        markedBaseCommitFgColor = ["${colors.blue}"];
        markedBaseCommitBgColor = ["${colors.yellow}"];
        unstagedChangesColor = ["${colors.red1}"];
        defaultFgColor = ["${colors.fg}"];
      };
    };
  };

  xdg.configFile."btop/themes/tokyonight.theme".text = ''
    theme[main_bg]="${colors.bg}"
    theme[main_fg]="${colors.fg}"
    theme[title]="${colors.fg}"
    theme[hi_fg]="${colors.orange}"
    theme[selected_bg]="${colors.bg1}"
    theme[selected_fg]="${colors.aqua}"
    theme[proc_misc]="${colors.aqua}"
    theme[cpu_box]="${colors.teal}"
    theme[mem_box]="${colors.teal}"
    theme[net_box]="${colors.teal}"
    theme[proc_box]="${colors.teal}"
    theme[div_line]="${colors.teal}"
    theme[temp_start]="${colors.green}"
    theme[temp_mid]="${colors.yellow}"
    theme[temp_end]="${colors.red}"
    theme[cpu_start]="${colors.green}"
    theme[cpu_mid]="${colors.yellow}"
    theme[cpu_end]="${colors.red}"
    theme[free_start]="${colors.green}"
    theme[free_mid]="${colors.yellow}"
    theme[free_end]="${colors.red}"
    theme[cached_start]="${colors.green}"
    theme[cached_mid]="${colors.yellow}"
    theme[cached_end]="${colors.red}"
    theme[available_start]="${colors.green}"
    theme[available_mid]="${colors.yellow}"
    theme[available_end]="${colors.red}"
    theme[used_start]="${colors.green}"
    theme[used_mid]="${colors.yellow}"
    theme[used_end]="${colors.red}"
    theme[download_start]="${colors.green}"
    theme[download_mid]="${colors.yellow}"
    theme[download_end]="${colors.red}"
    theme[upload_start]="${colors.green}"
    theme[upload_mid]="${colors.yellow}"
    theme[upload_end]="${colors.red}"
  '';

  home.packages = with pkgs; [
    fd
    sd
    ripgrep
    jq
    curl
    wget
    rsync
    tree
    procs
    ouch
  ];
}
