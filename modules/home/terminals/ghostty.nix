{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "TokyoNight Night";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10;
      window-padding-x = 10;
      keybind = [
        "ctrl+a>c=new_tab"
        "ctrl+a>x=close_tab"
        "ctrl+a>p=previous_tab"
        "ctrl+a>n=next_tab"
        "ctrl+a>-=new_split:down"
        "ctrl+a>|=new_split:right"
        "ctrl+a>z=toggle_split_zoom"
      ];
    };
  };
}
