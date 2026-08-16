#!/bin/bash
set -euo pipefail

query=${1:-}

if [[ -z $query ]]; then
  printf '[]\n'
  exit 0
fi

fd --type f --hidden --exclude .git --exclude .cache --exclude node_modules --print0 . "$HOME" |
  fzf --read0 --print0 --filter "$query" |
  jq -Rsc 'split("\u0000") | map(select(length > 0)) | .[:20]'
