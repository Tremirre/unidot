-- Keep Omarchy's default SUPER bindings, except use Super+tilde for the root menu.
local function send_key_to_ghostty(mods, key)
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end

local function active_window_is_tmux_ghostty()
  local window = hl.get_active_window()
  return window and window.class == "com.mitchellh.ghostty" and (window.title or ""):match("^tmux:")
end

local function tmux_pane_or_group_move(key, direction)
  return function()
    if active_window_is_tmux_ghostty() then
      -- Use an unbound bridge chord so the synthetic event is not recaptured here.
      send_key_to_ghostty("SUPER CTRL ALT", key)
    else
      hl.dispatch(hl.dsp.window.move({ into_group = direction }))
    end
  end
end

hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + GRAVE")
hl.unbind("SUPER + ALT + SPACE")
hl.unbind("SUPER + SHIFT + D")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + W")
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")
o.bind("SUPER + GRAVE", "Omarchy menu", "omarchy menu")
o.bind("ALT + GRAVE", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + SHIFT + Q", "Omawrite", { launch = "omawrite" })
o.bind("SUPER + W", "Close tmux pane or window", function()
  if active_window_is_tmux_ghostty() then
    send_key_to_ghostty("SUPER", "W")
  else
    hl.dispatch(hl.dsp.window.close())
  end
end)
o.bind("SUPER + ALT + LEFT", "Focus tmux pane left", tmux_pane_or_group_move("LEFT", "l"))
o.bind("SUPER + ALT + RIGHT", "Focus tmux pane right", tmux_pane_or_group_move("RIGHT", "r"))
o.bind("SUPER + ALT + UP", "Focus tmux pane up", tmux_pane_or_group_move("UP", "u"))
o.bind("SUPER + ALT + DOWN", "Focus tmux pane down", tmux_pane_or_group_move("DOWN", "d"))
