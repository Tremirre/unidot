#!/bin/bash
set -euo pipefail

query=${1:-}
history="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/clipboard-history.json"

if [[ ! -r $history ]]; then
  printf '[]\n'
  exit 0
fi

jq -c --arg query "$query" '
  ($query | ascii_downcase) as $needle
  | to_entries
  | map(
      .key as $index
      | .value as $entry
      | if $entry.type == "text" and ($entry.text | type) == "string" then
          {
            type: "text",
            index: $index,
            label: ($entry.text | gsub("\\s+"; " ") | .[:160]),
            detail: "Clipboard text",
            path: "",
            mime: "text/plain"
          }
        elif $entry.type == "image" and ($entry.path | type) == "string" then
          {
            type: "image",
            index: $index,
            label: (if $entry.mime == "image/png" then "Screenshot" else "Image" end),
            detail: ([($entry.capturedAt // ""), ($entry.mime // "image/png")] | map(select(length > 0)) | join(" · ")),
            path: $entry.path,
            mime: ($entry.mime // "image/png")
          }
        else empty end
    )
  | map(select($needle == "" or ((.label + " " + .detail) | ascii_downcase | contains($needle))))
  | .[:20]
' "$history"
