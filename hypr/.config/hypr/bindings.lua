-- Keep Omarchy's default SUPER bindings, except use Super+tilde for the root menu.
local function send_super_w_to_ghostty()
  hl.dispatch(hl.dsp.send_key_state({ mods = "SUPER", key = "W", state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = "SUPER", key = "W", state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end

hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + GRAVE")
hl.unbind("SUPER + ALT + SPACE")
hl.unbind("SUPER + SHIFT + D")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + W")
o.bind("SUPER + GRAVE", "Omarchy menu", "omarchy menu")
o.bind("ALT + GRAVE", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + SHIFT + Q", "Omawrite", { launch = "omawrite" })
o.bind("SUPER + W", "Close tmux pane or window", function()
  local window = hl.get_active_window()
  if window and window.class == "com.mitchellh.ghostty" and (window.title or ""):match("^tmux:") then
    send_super_w_to_ghostty()
  else
    hl.dispatch(hl.dsp.window.close())
  end
end)
