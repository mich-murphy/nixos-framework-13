{
  pkgs,
  colors,
  ...
}: {
  programs.git = {
    enable = true;

    ignores = [".venv" ".envrc" ".tox" "*.pyc"];

    settings = {
      user = {
        name = "Michael Murphy";
        email = "github@elmurphy.com";
      };
      init.defaultBranch = "main";
      fetch.prune = true;
      pull.rebase = true;
      merge = {
        conflictStyle = "zdiff3";
        autoStash = true;
      };
      rebase.autoStash = true;
      push.autoSetupRemote = true;
      commit = {
        verbose = true;
        cleanup = "scissors";
      };
      stash.showPatch = true;
      branch.sort = "-committerdate";
      diff = {
        colorMoved = "default";
        algorithm = "histogram";
        interHunkContext = 3;
      };
      "diff \"exiftool\"" = {
        textconv = "exiftool --composite -x 'Exiftool:*' -x 'File:*' -g0";
        cachetextconv = true;
        xfuncname = "^-.*$";
      };
      "diff \"pandoc-to-markdown\"" = {
        textconv = "pandoc --to markdown";
        cachetextconv = true;
      };
      interactive.singleKey = true;
      rerere.enabled = true;
      help.autoCorrect = "immediate";
      alias = {
        switch-recent = "!git branch --sort=-committerdate --format='%(refname:short)' | fzf --preview='git log --date=relative --color main..{}' | xargs git switch";
        rm-merged = "!git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" { print $1 }' | xargs -r git branch -D";
        sync = "!git switch main && git pull && git rm-merged";
        edit-unmerged = "!git diff --name-only --diff-filter U | xargs -r $(git var GIT_EDITOR)";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      hyperlinks = true;
      line-numbers = true;
      navigate = true;
      side-by-side = true;
      syntax-theme = "tokyonight_night";
      minus-style = "syntax \"${colors.diff_minus_bg}\"";
      minus-emph-style = "syntax \"${colors.diff_minus_emph_bg}\"";
      plus-style = "syntax \"${colors.diff_plus_bg}\"";
      plus-emph-style = "syntax \"${colors.diff_plus_emph_bg}\"";
      line-numbers-minus-style = colors.diff_minus_fg;
      line-numbers-plus-style = colors.diff_plus_fg;
      line-numbers-zero-style = colors.fg_gutter;
    };
  };

  xdg.configFile."git/attributes".text = ''
    *.bash diff=bash
    *.c diff=cpp
    *.cpp diff=cpp
    *.cs diff=csharp
    *.css diff=css
    *.ex diff=elixir
    *.exs diff=elixir
    *.go diff=golang
    *.h diff=c
    *.htm diff=html
    *.html diff=html
    *.java diff=java
    *.kt diff=kotlin
    *.kts diff=kotlin
    *.ktm diff=kotlin
    *.md diff=markdown
    *.m diff=matlab
    *.pas diff=pascal
    *.inc diff=pascal
    *.pp diff=pascal
    *.pl diff=perl
    *.php diff=php
    *.py diff=python
    *.pyi diff=python
    *.rb diff=ruby
    *.rs diff=rust
    *.sass diff=css
    *.scss diff=css
    *.sh diff=bash
    *.tex diff=tex
    *.zsh diff=bash
    *.avif diff=exiftool
    *.bmp diff=exiftool
    *.gif diff=exiftool
    *.jpeg diff=exiftool
    *.jpg diff=exiftool
    *.png diff=exiftool
    *.webp diff=exiftool
    *.docx diff=pandoc-to-markdown
    *.odt diff=pandoc-to-markdown
    *.ipynb diff=pandoc-to-markdown
    *.rtf diff=pandoc-to-markdown
  '';

  home.packages = with pkgs; [
    exiftool
    pandoc
    gh
  ];
}
