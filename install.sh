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

# Link shell aliases (sourced by .bashrc via ~/.bash_aliases)
link_file "$DOTFILES_DIR/aliases.sh" "$HOME/.bash_aliases"

# Link Neovim configuration
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Link Tmux configuration
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/tmux-sessionizer" "$HOME/.local/bin/tmux-sessionizer"
link_file "$DOTFILES_DIR/tmux-windowizer" "$HOME/.local/bin/tmux-windowizer"

# Link Claude Code configuration
echo ""
echo "Linking Claude Code configuration..."
mkdir -p "$HOME/.claude/hooks" "$HOME/.claude/skills"

link_file "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_file "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link_file "$DOTFILES_DIR/claude/settings.local.json" "$HOME/.claude/settings.local.json"
link_file "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
link_file "$DOTFILES_DIR/claude/hooks/send-to-telegram.sh" "$HOME/.claude/hooks/send-to-telegram.sh"

# Link each skill individually so locally-added skills are preserved
for skill_dir in "$DOTFILES_DIR/claude/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    link_file "$skill_dir" "$HOME/.claude/skills/$skill_name"
done

# --- 3. Auto-pull cron ---
echo ""
echo "Setting up dotfiles auto-pull..."

# Install cronie if crontab is not available
if ! command -v crontab &> /dev/null; then
    echo "crontab not found. Installing cronie..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm cronie
        sudo systemctl enable --now cronie
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y cron
        sudo systemctl enable --now cron
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y cronie
        sudo systemctl enable --now crond
    else
        echo "⚠️  Could not install cron. Please install it manually."
    fi
fi

CRON_CMD="cd $DOTFILES_DIR && git pull --ff-only --quiet 2>/dev/null"
CRON_ENTRY="0 9 * * * $CRON_CMD"

# Add cron job if crontab is available
if command -v crontab &> /dev/null; then
    if crontab -l 2>/dev/null | grep -qF "$DOTFILES_DIR" ; then
        echo "Dotfiles auto-pull cron already exists."
    else
        (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
        echo "Added cron: pull dotfiles daily at 9am."
    fi
else
    echo "⚠️  Skipping cron setup — crontab not available."
fi

# --- 4. Final Instructions ---
echo ""
echo "✅ Setup complete!"
echo "Next steps:"
echo "1. Start tmux and press 'prefix + I' (C-Space + I) to install tmux plugins."
echo "2. Start nvim and lazy.nvim should automatically install all neovim plugins."
echo "3. Optionally set TELEGRAM_BOT_TOKEN env var to enable the Telegram bridge hook."
