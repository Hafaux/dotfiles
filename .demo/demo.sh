#!/bin/bash

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$DEMO_DIR")"

cd "$DOTFILES_DIR"

# Check dependencies
command -v asciinema &>/dev/null || { echo "asciinema not found. brew install asciinema"; exit 1; }
command -v agg &>/dev/null || { echo "agg not found. brew install agg"; exit 1; }

# Remove symlinks for fresh demo
rm -f ~/.config/nvim/init.lua ~/.yabairc ~/.skhdrc ~/.zshrc ~/.gitconfig ~/.config/ghostty/config 2>/dev/null

# Record
COLUMNS=80 LINES=16 asciinema rec "$DEMO_DIR/demo.cast" --cols 80 --rows 16 --overwrite -c '
clear
sleep 0.3
printf "$ "
sleep 0.2
cmd="./install.sh"
for ((i=0; i<${#cmd}; i++)); do printf "%s" "${cmd:$i:1}"; sleep 0.04; done
sleep 0.2
printf "\n"
sleep 0.1
GUM_CONFIRM_TIMEOUT=1s ./install.sh
sleep 1
'

# Convert to gif
agg "$DEMO_DIR/demo.cast" "$DEMO_DIR/demo.gif" --font-family "JetBrainsMono Nerd Font" --font-size 16 --speed 1

echo ""
echo "Done! GIF saved to .demo/demo.gif"
echo "Run ./install.sh to restore your symlinks"
