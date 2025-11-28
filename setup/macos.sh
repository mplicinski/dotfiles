#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()  { printf "[${BLUE}INFO${RESET}] %s\n" "$1"; }
ok()    { printf "[${GREEN}OKAY${RESET}] %s\n" "$1"; }
warn()  { printf "[${YELLOW}WARN${RESET}] %s\n" "$1"; }
err()   { printf "[${RED}FAIL${RESET}] %s\n" "$1"; exit 1; }

set -e

info "macOS setup starting."

if ! command -v brew >/dev/null 2>&1; then
    info "Homebrew not found. Installing."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    info "Homebrew installed."
fi

info "Installing packages from Brewfile."
brew bundle --file="$HOME/.dotfiles/setup/Brewfile"

ok "macOS setup complete."
