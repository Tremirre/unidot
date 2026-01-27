#!/bin/bash

# Stow all package directories in the dotfiles repo
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DOTFILES_DIR" || exit 1

for dir in */; do
    # Skip if not a directory or if it starts with a dot
    [[ -d "$dir" ]] || continue
    
    pkg="${dir%/}"
    echo "Stowing $pkg..."
    stow "$pkg"
done

echo "Done!"
