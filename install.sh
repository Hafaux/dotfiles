#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Check for gum
if ! command -v gum &> /dev/null; then
    echo "gum not found. Install with: brew install gum"
    exit 1
fi

# Header
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    '✨ Dotfiles Installer ✨'

echo ""
gum style --foreground 240 "Installing from: $DOTFILES_DIR"
echo ""

# Confirm
gum confirm "Ready to install dotfiles?" || exit 0

echo ""

backup_and_link() {
    local source="$1"
    local target="$2"
    local name="$3"
    local target_dir="$(dirname "$target")"

    # Create target directory if needed
    [[ ! -d "$target_dir" ]] && mkdir -p "$target_dir"

    # Handle existing file/symlink
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            local current_link="$(readlink "$target")"
            if [[ "$current_link" == "$source" ]]; then
                gum style --foreground 240 "  ○ $name (already linked)"
                return
            fi
            rm "$target"
        else
            mkdir -p "$BACKUP_DIR"
            mv "$target" "$BACKUP_DIR/"
        fi
    fi

    ln -s "$source" "$target"
    gum style --foreground 212 "  ● $name"
}

# Install configs
gum spin --spinner dot --title "Linking configs..." -- sleep 0.5

backup_and_link "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua" "nvim"
backup_and_link "$DOTFILES_DIR/yabai/yabairc" "$HOME/.yabairc" "yabai"
backup_and_link "$DOTFILES_DIR/skhd/skhdrc" "$HOME/.skhdrc" "skhd"
backup_and_link "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc" "zsh"
backup_and_link "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig" "git"

echo ""

if [[ -d "$BACKUP_DIR" ]]; then
    gum style --foreground 214 "📦 Backups: $BACKUP_DIR"
    echo ""
fi

gum style --foreground 82 --bold "✓ Done!"
echo ""
