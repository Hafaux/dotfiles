#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Check for gum, install if missing
if ! command -v gum &> /dev/null; then
    echo "Installing gum..."
    brew install gum
fi

# Define configs: source|target|name
CONFIGS=(
    "nvim/init.lua|$HOME/.config/nvim/init.lua|nvim"
    "yabai/yabairc|$HOME/.yabairc|yabai"
    "skhd/skhdrc|$HOME/.skhdrc|skhd"
    "zsh/zshrc|$HOME/.zshrc|zsh"
    "git/gitconfig|$HOME/.gitconfig|git"
    "ghostty/config|$HOME/.config/ghostty/config|ghostty"
    "tmux/tmux.conf|$HOME/.tmux.conf|tmux"
    "bin/tmux-sessionizer|$HOME/bin/tmux-sessionizer|tmux-sessionizer"
)

# Check link status
check_status() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"
    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        return 0  # linked
    fi
    return 1  # not linked
}


# Check all configs and build lists
LINKED=()
NOT_LINKED=()

for config in "${CONFIGS[@]}"; do
    IFS='|' read -r source target name <<< "$config"
    if check_status "$source" "$target"; then
        LINKED+=("$name")
    else
        NOT_LINKED+=("$name")
    fi
done

# Display status
if [[ ${#LINKED[@]} -gt 0 ]]; then
    gum style --foreground 240 "Already linked:"
    for name in "${LINKED[@]}"; do
        gum style --foreground 240 "  ○ $name"
    done
    echo ""
fi

if [[ ${#NOT_LINKED[@]} -gt 0 ]]; then
    gum style --foreground 212 "Not linked:"
    for name in "${NOT_LINKED[@]}"; do
        gum style --foreground 212 "  ● $name"
    done
    echo ""
fi

# Exit early if everything is linked
if [[ ${#NOT_LINKED[@]} -eq 0 ]]; then
    gum style --foreground 82 --bold "All dotfiles already linked!"
    echo ""
    exit 0
fi

# Confirm
gum confirm --default --timeout="${GUM_CONFIRM_TIMEOUT:-0s}" "Link ${#NOT_LINKED[@]} config(s)?" || exit 0

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
            rm "$target"
        else
            mkdir -p "$BACKUP_DIR"
            mv "$target" "$BACKUP_DIR/"
        fi
    fi

    ln -s "$source" "$target"
    gum style --foreground 212 "  ● $name"
}

# Install only unlinked configs
gum spin --spinner dot --title "Linking configs..." -- sleep 0.5

for config in "${CONFIGS[@]}"; do
    IFS='|' read -r source target name <<< "$config"
    if ! check_status "$source" "$target"; then
        backup_and_link "$DOTFILES_DIR/$source" "$target" "$name"
    fi
done

echo ""

if [[ -d "$BACKUP_DIR" ]]; then
    gum style --foreground 214 "Backups: $BACKUP_DIR"
    echo ""
fi

# Make scripts executable
chmod +x "$HOME/bin/tmux-sessionizer" 2>/dev/null || true

gum style --foreground 82 --bold "Done!"
echo ""
