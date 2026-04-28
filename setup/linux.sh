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

info "Linux/WSL setup starting."

# Detect WSL
is_wsl=false
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    is_wsl=true
fi

# Ensure script is running on a linux system
if ! command -v apt >/dev/null 2>&1; then
    err "apt not found. linux.sh is intended for Ubuntu/Debian/WSL."
fi

# Helper function to check if package is installed
is_pkg_installed() {
    local pkg="$1"
    dpkg-query -W -f='${Status}\n' "$pkg" 2>/dev/null | grep -q "install ok installed"
}

info "Updating apt package index."
sudo apt update

info "Installing CLI tools."
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
    python3-pip
    ca-certificates
    unzip
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Check for missing packages and install them
MISSING_PACKAGES=()
for pkg in "${PACKAGES[@]}"; do
    if ! is_pkg_installed "$pkg"; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [ "${#MISSING_PACKAGES[@]}" -gt 0 ]; then
    info "Missing packages: ${MISSING_PACKAGES[*]}"
    sudo apt install -y "${MISSING_PACKAGES[@]}"
    ok "Installed missing CLI tools."
else
    ok "All CLI tools already installed. Skipping."
fi

info "Installing pynvim for Neovim Python support."
pip3 install --user pynvim >/dev/null 2>&1 || true

info "Ensuring ~/.local/bin exists and is on PATH."
mkdir -p "$HOME/.local/bin"

# Check if ~/.local/bin is already in PATH
case ":$PATH:" in
  *":$HOME/.local/bin:"*)
    ok "~/.local/bin already in PATH."
    ;;
  *)
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.profile" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
        ok "Added ~/.local/bin to PATH in ~/.profile."
    else
        ok "~/.local/bin already referenced in ~/.profile."
    fi

    export PATH="$HOME/.local/bin:$PATH"
    info "Updated PATH for current session."
    ;;
esac

info "Installing Oh-My-Posh via official installer."
if command -v oh-my-posh >/dev/null 2>&1; then
    ok "oh-my-posh already installed. Skipping."
else
    curl -s https://ohmyposh.dev/install.sh | bash -s || {
        err "oh-my-posh installation failed."
    }
    ok "oh-my-posh installed successfully."
fi

if [ "$is_wsl" = true ]; then
    info "Detected WSL. Setting up win32yank for clipboard integration."
    if ! command -v win32yank.exe >/dev/null 2>&1; then
        cd /tmp
        wget -q https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
        unzip -o win32yank-x64.zip >/dev/null
        sudo mv win32yank.exe /usr/local/bin/
        sudo chmod +x /usr/local/bin/win32yank.exe
        ok "win32yank installed."
    else
        ok "win32yank.exe already present in PATH. Skipping."
    fi
else
    info "Not WSL, skipping win32yank setup."
fi

ok "Linux/WSL setup complete."
