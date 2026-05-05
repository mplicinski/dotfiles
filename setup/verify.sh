#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()  { printf "[${BLUE}INFO${RESET}] %s\n" "$1"; }
ok()    { printf "[${GREEN}OKAY${RESET}] %s\n" "$1"; }
warn()  { printf "[${YELLOW}WARN${RESET}] %s\n" "$1"; }
err()   { printf "[${RED}FAIL${RESET}] %s\n" "$1"; }

printf "Checking symlinks...\n"
targets=(
  "$HOME/.zshrc"
  "$HOME/.gitconfig"
  "$HOME/.tmux.conf"
  "$HOME/.config/nvim"
  "$HOME/.config/oh-my-posh"
  "$HOME/.config/fastfetch"
  "$HOME/.ascii"
)

# Karabiner config check on macOS
if [[ "$(uname)" == "Darwin" ]]; then
  targets+=("$HOME/.config/karabiner/karabiner.json")
fi

for file in "${targets[@]}"; do
  if [ -L "$file" ]; then
    ok "$file -> $(readlink "$file")"
  else
    err "Missing or not a symlink: $file"
  fi
done

printf "\n"
printf "Checking CLI tools...\n"

tools=(zsh git nvim tmux fzf rg curl wget tree pip3 unzip fastfetch)

for tool in "${tools[@]}"; do
  if command -v $tool >/dev/null 2>&1; then
    ok "$tool installed"
  else
    err "$tool missing"
  fi
done
