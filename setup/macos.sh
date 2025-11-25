#!/usr/bin/env bash

set -e

echo "[+] macOS setup starting."

if ! command -v brew >/dev/null 2>&1; then
    echo "[+] Homebrew not found. Installing."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "[+] Homebrew installed."
fi

echo "[+] Installing packages from Brewfile."
brew bundle --file="$HOME/.dotfiles/Brewfile"

echo "[+] macOS setup complete."
