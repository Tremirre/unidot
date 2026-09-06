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

menu_dir="$target_root/barti.menu"
mkdir -p "$menu_dir"
cp -a "${OMARCHY_PATH:-/usr/share/omarchy}/shell/plugins/menu"/. "$menu_dir"/
cp -a "$plugin_root/barti.menu/manifest.json" "$menu_dir"/
cp -a "$plugin_root/barti.menu/file-search.sh" "$plugin_root/barti.menu/clipboard-search.sh" "$menu_dir"/
rm -f "$menu_dir/Menu.qml.orig" "$menu_dir/Menu.qml.rej"
patch --batch --no-backup-if-mismatch -d "$menu_dir" -p1 < "$plugin_root/barti.menu/Menu.patch"
patch --batch --no-backup-if-mismatch -d "$menu_dir" -p1 < "$plugin_root/barti.menu/Calculator.patch"
patch --batch --no-backup-if-mismatch -d "$menu_dir" -p1 < "$plugin_root/barti.menu/Search.patch"

agents_dir="$target_root/barti.agents"
mkdir -p "$agents_dir"
cp -a "${OMARCHY_PATH:-/usr/share/omarchy}/shell/plugins/agents"/. "$agents_dir"/
cp -a "$plugin_root/barti.agents/manifest.json" "$agents_dir"/
rm -f "$agents_dir/Main.qml.orig" "$agents_dir/Main.qml.rej" "$agents_dir/Panel.qml.orig" "$agents_dir/Panel.qml.rej"
patch --batch --no-backup-if-mismatch -d "$agents_dir" -p1 < "$plugin_root/barti.agents/Main.patch"
patch --batch --no-backup-if-mismatch -d "$agents_dir" -p1 < "$plugin_root/barti.agents/Panel.patch"

# Custom agent usage collectors (picked up by omarchy-agent-usage-update
# from $OMARCHY_PATH/bin). Needs sudo; skipped when not available.
if [ -f "$plugin_root/bin/omarchy-agent-usage-opencode" ]; then
  if sudo -n true 2>/dev/null; then
    sudo cp -a "$plugin_root/bin/omarchy-agent-usage-opencode" /usr/bin/omarchy-agent-usage-opencode
    sudo ln -sf /usr/bin/omarchy-agent-usage-opencode "${OMARCHY_PATH:-/usr/share/omarchy}/bin/omarchy-agent-usage-opencode"
    # codex-cli dropped the 'untrusted' approval policy; without this the
    # limits probe fails and the Codex tab shows no limits.
    if grep -q '"-a", "untrusted"' /usr/bin/omarchy-agent-usage-codex 2>/dev/null; then
      sudo sed -i 's/\[codex, "-s", "read-only", "-a", "untrusted", "app-server"\]/[codex, "app-server"]/' /usr/bin/omarchy-agent-usage-codex
    fi
    # Daily per-model history for the Day/Week/Month model ranges (--forward:
    # skip when already applied).
    sudo patch --batch --forward --no-backup-if-mismatch -d /usr/bin -p1 < "$plugin_root/barti.agents/Codex.patch" || true
    sudo ln -sf /usr/bin/omarchy-agent-usage-codex "${OMARCHY_PATH:-/usr/share/omarchy}/bin/omarchy-agent-usage-codex" || true
  else
    echo "install.sh: skipping agent usage collectors (needs sudo; run stow-all.sh in a terminal)" >&2
  fi
fi

"$plugin_root/../../scripts/apply-omarchy-lock-theme.sh"
