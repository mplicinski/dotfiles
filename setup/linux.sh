#!/usr/bin/env bash

set -e

echo "[+] Linux/WSL setup starting."

# Detect WSL
is_wsl=false
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    is_wsl=true
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "[!] apt not found. linux.sh is intended for Debian/Ubuntu/WSL."
    exit 1
fi

echo "[+] Updating apt."
sudo apt update

echo "[+] Installing common CLI tools."
PACKAGES=(
    zsh
    tmux
    neovim
    curl
    wget
    git
    fzf
    ripgrep
    tree
)

sudo apt install -y "${PACKAGES[@]}"

echo "[+] Installing pynvim for Neovim Python support."
pip3 install --user pynvim || true

echo "[+] Installing Oh-My-Posh."
sudo apt install -y oh-my-posh

if [ "$is_wsl" = true ]; then
    echo "[+] Detected WSL. Setting up win32yank for clipboard integration."
    if ! command -v win32yank.exe >/dev/null 2>&1; then
        cd /tmp
        wget -q https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
        unzip -o win32yank-x64.zip >/dev/null
        sudo mv win32yank.exe /usr/local/bin/
        sudo chmod +x /usr/local/bin/win32yank.exe
        echo "[+] win32yank installed."
    else
        echo "[+] win32yank.exe already present, skipping."
    fi
else
    echo "[+] Not WSL, skipping win32yank."
fi

echo "[+] Linux/WSL setup complete."
