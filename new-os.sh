#!/bin/bash
set -euo pipefail

# Helper function for checking for package manager
has_command() {
    command -v "$1" >/dev/null 2>&1
}

if has_command apt-get; then
    echo "Update the system"
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y

    echo "Installing some utilities"
    sudo apt install -y git curl htop neovim build-essential cmake clangd gdb ripgrep fd-find tree tmux zip unzip python3 python3-pip python3-venv direnv

    # hooking direnv to the terminal
    grep -qxF 'eval "$(direnv hook bash)"' ~/.bashrc || echo 'eval "$(direnv hook bash)"' >>~/.bashrc

    echo "Installing vscode"
    sudo apt install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    rm packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code

    echo "Installing discord"
    if has_command snap; then
        sudo snap install discord
    elif has_command flatpak; then
        flatpak flathub com.discordapp.Discord
    else
        wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
        sudo apt install -y ./discord.deb
    fi

    echo "Installing lazyvim"
    mv ~/.config/nvim{,.bak} || echo "Can't backup nvim configs"
    mv ~/.local/share/nvim{,.bak} || echo "Can't backup nvim shares"
    mv ~/.local/state/nvim{,.bak} || echo "Can't backup nvim state"
    mv ~/.cache/nvim{,.bak} || echo "Can't backup nvim cache"
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git

    echo "Installing nerdfont"
    mkdir -p ~/.local/share/fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
    fc-cache -fv
    rm JetBrainsMono.zip

    echo "Config git email and username"
    git config --global user.name "Gabriel Enrique Angulo Gonzalez"
    git config --global user.email "gaboangulo1@gmail.com"

    echo "Lastly install any drivers that might be missing (this only works for ubuntu, mint, and debian)"
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO_ID="$ID"
    else
        echo "Distro ID not found"
    fi
    if has_command ubuntu-drivers; then
        sudo ubuntu-drivers install
    fi

    echo "One last update..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

    echo "Done! Now, here's what you want to do: 1) Restart the terminal 2) Load nvim to fully install lazyvim and wait for it to fully install (usually like 30 mins) and 3) Restart the terminal again"
fi
