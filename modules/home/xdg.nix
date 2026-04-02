{...}: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/png" = "gimp.desktop";
        "image/jpeg" = "gimp.desktop";
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "inode/directory" = "org.kde.dolphin.desktop";
      };
    };
  };
}
