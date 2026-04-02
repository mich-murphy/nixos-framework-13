{
  pkgs,
  lib,
  colors,
  ...
}: let
  c = builtins.mapAttrs (_: lib.removePrefix "#") colors;
in {
  xdg.configFile."fish/themes/tokyonight_night.theme".text = ''
    fish_color_normal ${c.fg}
    fish_color_command ${c.aqua}
    fish_color_keyword ${c.purple}
    fish_color_quote ${c.yellow}
    fish_color_redirection ${c.fg}
    fish_color_end ${c.orange}
    fish_color_option ${c.purple}
    fish_color_error ${c.red}
    fish_color_param ${c.purple0}
    fish_color_comment ${c.comment}
    fish_color_selection --background=${c.bg2}
    fish_color_search_match --background=${c.bg2}
    fish_color_operator ${c.green}
    fish_color_escape ${c.purple}
    fish_color_autosuggestion ${c.comment}
    fish_pager_color_progress ${c.comment}
    fish_pager_color_prefix ${c.aqua}
    fish_pager_color_completion ${c.fg}
    fish_pager_color_description ${c.comment}
    fish_pager_color_selected_background --background=${c.bg2}
  '';

  programs.fish = {
    enable = true;

    loginShellInit = ''
      set -x BROWSER firefox
    '';

    interactiveShellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      set -g fish_greeting
      fish_config theme choose tokyonight_night
    '';

    shellAliases = {
      cat = "bat";
    };

    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };
}
