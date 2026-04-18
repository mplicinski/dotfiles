# Platform detection
IS_DARWIN=false
IS_WSL=false

case "$(uname -s)" in
  Darwin)
    IS_DARWIN=true
    ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
      IS_WSL=true
    fi
    ;;
esac

# Always start in $HOME if opening a login shell
if [[ "$PWD" != "$HOME" ]] && [[ -z "$WSLENV_LOADED" ]]; then
  cd "$HOME"
fi

# ASCII startup art
if [[ -z "$ASCII_SHOWN" ]]; then
  clear

  if $IS_WSL; then
    # Nimbus banner on WSL
    [[ -f "$HOME/.ascii/nimbus.ascii" ]] && cat "$HOME/.ascii/nimbus.ascii"
  elif $IS_DARWIN; then
    # Apple banner on macOS
    [[ -f "$HOME/.ascii/apple.ascii" ]] && cat "$HOME/.ascii/apple.ascii"
  fi

  echo
  export ASCII_SHOWN=1
fi

# --- Basic settings (shared) ---

# Default editor
export EDITOR=vim   # swap to nvim later if you want

# History configuration
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt hist_ignore_all_dups
setopt share_history
setopt inc_append_history

# Useful options
setopt autocd          # type a directory name to cd into it
setopt correct         # typo correction for commands
setopt extended_glob   # extended wildcard matching

# PATH base (shared)
# Local bin
export PATH="$HOME/.local/bin:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"

# -------------------------------

# macOS-specific paths & tools
if $IS_DARWIN; then
  # Homebrew
  export PATH="/opt/homebrew/bin:$PATH"

  # User Python tools
  export PATH="$HOME/Library/Python/3.9/bin:$PATH"

  # pnpm on macOS
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac

  # jenv only if installed
  if command -v jenv >/dev/null 2>&1; then
    eval "$(jenv init -)"
  fi
fi

# Prompt: oh-my-posh if available, fallback otherwise
if [ "$TERM_PROGRAM" != "Apple_Terminal" ] && command -v oh-my-posh >/dev/null 2>&1; then
  # Shared oh-my-posh config (works on macOS + WSL)
  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/powerlevel10k_amber.omp.json")"
else
  # Fallback prompt 
  autoload -Uz colors promptinit
  promptinit
  colors
  PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f %# '
fi

# Command re-print / preserve-header behavior
if [[ -z "$CMD_HIGHLIGHT_ALREADY_BINDED" ]]; then
  autoload -Uz add-zsh-hook

  # Reprint the command line before execution to preserve header above it
  preserve_header() {
    [[ -n $BUFFER ]] && print -Pn "❯ $BUFFER\n"
    zle .accept-line
  }

  zle -N preserve_header
  bindkey '^M' preserve_header

  export CMD_HIGHLIGHT_ALREADY_BINDED=1
fi

# Helper functions
git-branches() {
  {
    git for-each-ref --sort=-committerdate --format='%(committerdate:iso8601) local  %(refname:short)' refs/heads/
    git for-each-ref --sort=-committerdate --format='%(committerdate:iso8601) remote %(refname:short)' refs/remotes/
  } | awk '!seen[$3]++' | sort -r | column -t
}
