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
    extraPackages =
      builtins.attrValues {
        # nvim-treesitter parser build deps
        inherit (pkgs) tree-sitter gcc;
        # Snacks.image rendering deps
        inherit (pkgs) imagemagick ghostscript mermaid-cli;
        # Snacks.explorer trash support
        inherit (pkgs) trash-cli;
        # Mason installer deps (unzip for archives, npm via nodejs, go toolchain)
        inherit (pkgs) unzip nodejs go;
        # Tools normally installed via Mason — provided by Nix to avoid
        # Mason's pre-built binaries failing on NixOS (no patched dynamic linker).
        inherit (pkgs) stylua tflint gofumpt delve;
        inherit (pkgs) gotools; # provides goimports
        inherit (pkgs) markdownlint-cli2 markdown-toc prettier ruff marksman nixd alejandra;
      }
      ++ [pkgs.vscode-extensions.vadimcn.vscode-lldb]; # provides codelldb
  };
}
