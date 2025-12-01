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

set -e

DOTFILES="$HOME/.dotfiles"

# Helper function for symlinking and logging
link() {
  local src="$1"
  local dest="$2"

  # If dest is already the correct symlink, skip
  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      ok "Already linked: $dest -> $src (skipping)"
      return
    fi
  fi

  # If dest exists (file, dir, or wrong symlink), back it up
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.backup.$(date +%s)"
    info "Backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi

  info "Linking $src -> $dest"
  ln -s "$src" "$dest"
}

info "Setting up symlinks"

# Top-level dotfiles
link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

# Config directory
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/karabiner"
link "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"
link "$DOTFILES/oh-my-posh/.config/oh-my-posh" "$HOME/.config/oh-my-posh"
link "$DOTFILES/karabiner/.config/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# ASCII login banner art folder 
link "$DOTFILES/ascii" "$HOME/.ascii"

ok "Done."
