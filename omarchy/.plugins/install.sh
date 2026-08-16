#!/bin/bash
set -euo pipefail

plugin_root="$(cd "$(dirname "$0")" && pwd)"
target_root="$HOME/.config/omarchy/plugins"

install_plugin() {
  local source_dir="$1"
  local target_dir="$target_root/${source_dir##*/}"
  mkdir -p "$target_dir"
  cp -a "$source_dir"/. "$target_dir"/
}

install_plugin "$plugin_root/barti.system-stats"

bar_dir="$target_root/barti.bar"
mkdir -p "$bar_dir"
cp -a "${OMARCHY_PATH:-/usr/share/omarchy}/shell/plugins/bar"/. "$bar_dir"/
cp -a "$plugin_root/barti.bar/manifest.json" "$bar_dir"/
rm -f "$bar_dir/Bar.qml.orig" "$bar_dir/Bar.qml.rej"
patch --batch --no-backup-if-mismatch -d "$bar_dir" -p1 < "$plugin_root/barti.bar/Bar.patch"
