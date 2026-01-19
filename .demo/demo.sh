#!/bin/bash
cd /Users/tolis/code/dotfiles
clear
sleep 0.5
echo -n "$ "
sleep 0.3
# Simulate typing
for char in ./ i n s t a l l . s h; do
    echo -n "$char"
    sleep 0.05
done
sleep 0.3
echo ""
sleep 0.2

# Run install with auto-confirm after brief pause
export GUM_CONFIRM_TIMEOUT=1s
./install.sh

sleep 1.5
