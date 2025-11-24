eval "$(jenv init -)"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/mplicinski/Library/Python/3.9/bin:$PATH"

# Initialize Oh My Posh unless we're in Apple Terminal (which doesn't render properly)
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/powerlevel10k_amber.omp.json)"
fi

# Only bind if not already done
if [[ -z "$CMD_HIGHLIGHT_ALREADY_BINDED" ]]; then
  autoload -Uz add-zsh-hook

  # Reprint the command line before execution to preserve header above it
  function preserve_header() {
    [[ -n $BUFFER ]] && print -Pn "❯ $BUFFER\n"
    zle .accept-line
  }

  zle -N preserve_header
  bindkey '^M' preserve_header

  export CMD_HIGHLIGHT_ALREADY_BINDED=1
fi

git-branches() {
  {
    git for-each-ref --sort=-committerdate --format='%(committerdate:iso8601) local %(refname:short)' refs/heads/
    git for-each-ref --sort=-committerdate --format='%(committerdate:iso8601) remote %(refname:short)' refs/remotes/
  } | awk '!seen[$3]++' | sort -r | column -t
}

# pnpm
export PNPM_HOME="/Users/mplicinski/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
