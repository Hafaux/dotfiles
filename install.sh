#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

backup_and_link() {
    local source="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    # Create target directory if it doesn't exist
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        log_info "Created directory: $target_dir"
    fi

    # Handle existing file/symlink
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            local current_link="$(readlink "$target")"
            if [[ "$current_link" == "$source" ]]; then
                log_info "Already linked: $target -> $source"
                return
            fi
            log_warn "Removing existing symlink: $target -> $current_link"
            rm "$target"
        else
            mkdir -p "$BACKUP_DIR"
            log_warn "Backing up: $target -> $BACKUP_DIR/"
            mv "$target" "$BACKUP_DIR/"
        fi
    fi

    ln -s "$source" "$target"
    log_info "Linked: $target -> $source"
}

main() {
    echo ""
    echo "Installing dotfiles from: $DOTFILES_DIR"
    echo ""

    # nvim
    backup_and_link "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

    # yabai
    backup_and_link "$DOTFILES_DIR/yabai/yabairc" "$HOME/.yabairc"

    # skhd
    backup_and_link "$DOTFILES_DIR/skhd/skhdrc" "$HOME/.skhdrc"

    # zsh
    backup_and_link "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

    # git
    backup_and_link "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

    echo ""
    log_info "Done! Dotfiles installed successfully."

    if [[ -d "$BACKUP_DIR" ]]; then
        echo ""
        log_warn "Backups saved to: $BACKUP_DIR"
    fi
}

main "$@"
