{pkgs, ...}: {
  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 20;
    gtk.enable = true;
  };
}
