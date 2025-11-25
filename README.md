# Dotfiles

My dotfiles for both MacOS & Linux. Includes essentials tools & packages, setup scripts, and enviroment specific configurations. 

It uses symlinks so the real files live here in the repo, and the system just points to them. 

---

## Included Configurations

- `.zshrc` (shell config)
- `.gitconfig`
- `.tmux.conf`
- Neovim config under `~/.config/nvim`
- Oh-My-Posh themes
- Optional: Karabiner config for macOS
---

## Prerequisites

### macOS (Homebrew required)

If Homebrew isn't installed:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Linux (Ubuntu/Arch/Debian)

Update first:
```sh
sudo apt update && sudo apt upgrade -y
```

---

## Installation

Clone the repository:
```sh
git clone git@github.com:mplicinski/dotfiles.git ~/.dotfiles
```

### Setup on MacOS

Make sure the scripts are executable
```sh
cd ~/.dotfiles/setup/
chmod +x bootstrap.sh macos.sh verify.sh
```

Run the setup scripts
```sh
./macos.sh
./bootstrap.sh

exec zsh
```

### Setup on Linux/ WSL

Make sure the scripts are executable
```sh
cd ~/.dotfiles/setup/
chmod +x bootstrap.sh linux.sh verify.sh
```

Run the setup scripts
```sh
./linux.sh
./bootstrap.sh

exec zsh
```

## Verifying the Setup

If running script for the first time make sure it is executable:
```sh
chmod +x ~/.dotfiles/setup/verify.sh
```

Run the verify script:
```sh
~/.dotfiles/setup/verify.sh
```
