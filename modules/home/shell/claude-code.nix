{pkgs, ...}: let
  statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = with pkgs; [jq coreutils gawk];
    text = ''
      input=$(cat)

      model=$(jq -r '.model.display_name // "Claude"' <<<"$input")
      cost_usd=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
      transcript=$(jq -r '.transcript_path // ""' <<<"$input")

      context=0
      if [[ -n "$transcript" && -f "$transcript" ]]; then
        context=$(tac "$transcript" \
          | jq -r 'select(.message.usage) | .message.usage
                   | (.input_tokens // 0)
                   + (.cache_read_input_tokens // 0)
                   + (.cache_creation_input_tokens // 0)' 2>/dev/null \
          | head -n1)
        context=''${context:-0}
      fi

      ctx_k=$(awk -v t="$context" 'BEGIN { printf "%dk", (t + 500) / 1000 }')
      cost_fmt=$(awk -v c="$cost_usd" 'BEGIN { printf "$%.2f", c }')

      dim=$'\033[2m'
      reset=$'\033[0m'
      sep="''${dim} · ''${reset}"

      printf '%s%sctx %s%s%s' "$model" "$sep" "$ctx_k" "$sep" "$cost_fmt"
    '';
  };
in {
  home.packages = [
    pkgs.claude-code
    statusline
  ];
}
