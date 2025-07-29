#!/bin/bash

# This script installs dependencies and creates symlinks for the dotfiles.

set -e # Exit immediately if a command exits with a non-zero status.

# Get the absolute path of the script's directory (your dotfiles repo)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Starting dotfiles setup..."

# --- 1. Install Dependencies ---
echo ""
echo "Installing dependencies..."

# Install Tmux Plugin Manager (TPM) if it doesn't exist
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM already installed."
fi

# --- 2. Create Symlinks ---
echo ""
echo "Linking configuration files..."

# Function to create a symlink and back up any existing file
link_file() {
    local source_file=$1
    local target_file=$2

    # If a file or link exists at the target, back it up.
    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        # Ensure the backup directory exists.
        mkdir -p "$BACKUP_DIR"
        echo "Backing up existing '$target_file' to $BACKUP_DIR"
        mv "$target_file" "$BACKUP_DIR/"
    fi

    # Ensure the parent directory of the target link exists.
    mkdir -p "$(dirname "$target_file")"

    # Create the new symlink.
    echo "Linking '$source_file' to '$target_file'"
    ln -s "$source_file" "$target_file"
}

# Link Neovim configuration
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Link Tmux configuration
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# --- 3. Final Instructions ---
echo ""
echo "✅ Setup complete!"
echo "Next steps:"
echo "1. Start tmux and press 'prefix + I' (C-Space + I) to install tmux plugins."
echo "2. Start nvim and lazy.nvim should automatically install all neovim plugins."
