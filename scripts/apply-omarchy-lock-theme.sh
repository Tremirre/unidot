#!/bin/bash
set -euo pipefail

script_path="$(readlink -f "${BASH_SOURCE[0]}")"
repo_dir="$(cd "$(dirname "$script_path")/.." && pwd)"
plugin_source="$repo_dir/omarchy/.plugins/barti.lock"
plugin_target="$HOME/.config/omarchy/plugins/barti.lock"

mkdir -p "$plugin_target"
cp -a "${OMARCHY_PATH:-/usr/share/omarchy}/shell/plugins/lock"/. "$plugin_target"/
cp -a "$plugin_source/manifest.json" "$plugin_target"/
rm -f "$plugin_target/LockView.qml.orig" "$plugin_target/LockView.qml.rej"
patch --batch --no-backup-if-mismatch -d "$plugin_target" -p1 < "$plugin_source/LockView.patch"
