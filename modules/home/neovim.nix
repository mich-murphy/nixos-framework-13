{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = false;
    initLua = ''
      require("config.lazy")
    '';
    extraPackages = with pkgs; [
      # nvim-treesitter parser build deps
      tree-sitter
      gcc
      # Snacks.image rendering deps
      imagemagick
      ghostscript
      mermaid-cli
      # Snacks.explorer trash support
      trash-cli
      # Mason installer deps (unzip for archives, npm via nodejs, go toolchain)
      unzip
      nodejs
      go
      # Tools normally installed via Mason — provided by Nix to avoid
      # Mason's pre-built binaries failing on NixOS (no patched dynamic linker).
      stylua
      tflint
      gofumpt
      delve
      gotools # provides goimports
      markdownlint-cli2
      markdown-toc
      prettier
      vscode-extensions.vadimcn.vscode-lldb # provides codelldb
    ];
  };
}
