#!/bin/bash
set -euo pipefail

source_dir="$(cd "$(dirname "$0")" && pwd)/barti.system-stats"
target_dir="$HOME/.config/omarchy/plugins/barti.system-stats"

mkdir -p "$target_dir"
cp -a "$source_dir"/. "$target_dir"/
