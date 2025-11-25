#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

link() {
  src=$1
  dest=$2

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "Backing up existing $dest -> $dest.backup"
    mv "$dest" "$dest.backup"
  fi

  echo "Linking $src -> $dest"
  ln -s "$src" "$dest"
}

echo "=== Setting up symlinks ==="

link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/karabiner"
link "$DOTFILES/nvim/.config/nvim" "$HOME/.config/nvim"
link "$DOTFILES/oh-my-posh/.config/oh-my-posh" "$HOME/.config/oh-my-posh"
link "$DOTFILES/karabiner/.config/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
echo "Done."
