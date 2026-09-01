-- Keep Omarchy's default SUPER bindings, except use Super+tilde for the root menu.
local function send_key_to_ghostty(mods, key, on_release)
  mods = mods or ""
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    if on_release then
      on_release()
    end
  end, { timeout = 50, type = "oneshot" })
end

local function active_window_is_ghostty_with_title(prefix)
  local window = hl.get_active_window()
  local title = window and window.title or ""
  return window and window.class == "com.mitchellh.ghostty" and title:match("^" .. prefix)
end

local function active_window_is_herdr_ghostty()
  return active_window_is_ghostty_with_title("herdr:")
end

local function active_window_is_tmux_ghostty()
  return active_window_is_ghostty_with_title("tmux:")
end

local function send_herdr_key(key, mods)
  -- Release Ctrl+A before the action key so Hyprland never sees a synthetic Super chord.
  send_key_to_ghostty("CTRL", "A", function()
    send_key_to_ghostty(mods, key)
  end)
end

local function multiplexer_pane_or_group_move(key, direction)
  return function()
    if active_window_is_herdr_ghostty() then
      send_herdr_key(key:lower())
    elseif active_window_is_tmux_ghostty() then
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
hl.unbind("SUPER + T")
hl.unbind("SUPER + W")
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")
o.bind("SUPER + GRAVE", "Omarchy menu", "omarchy menu")
o.bind("ALT + GRAVE", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + SHIFT + Q", "Omawrite", { launch = "omawrite" })
o.bind("SUPER + T", "New Herdr tab or toggle window floating/tiling", function()
  if active_window_is_herdr_ghostty() then
    send_herdr_key("C")
  elseif active_window_is_tmux_ghostty() then
    send_key_to_ghostty("SUPER", "T")
  else
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  end
end)
o.bind("SUPER + W", "Close Herdr/tmux pane or window", function()
  if active_window_is_herdr_ghostty() then
    send_herdr_key("X")
  elseif active_window_is_tmux_ghostty() then
    send_key_to_ghostty("SUPER", "W")
  else
    hl.dispatch(hl.dsp.window.close())
  end
end)
o.bind("SUPER + D", "Split Herdr pane", function()
  if active_window_is_herdr_ghostty() then
    send_herdr_key("backtick")
  elseif active_window_is_tmux_ghostty() then
    send_key_to_ghostty("SUPER", "D")
  end
end)
o.bind("SUPER + ALT + LEFT", "Focus Herdr/tmux pane left", multiplexer_pane_or_group_move("LEFT", "l"))
o.bind("SUPER + ALT + RIGHT", "Focus Herdr/tmux pane right", multiplexer_pane_or_group_move("RIGHT", "r"))
o.bind("SUPER + ALT + UP", "Focus Herdr/tmux pane up", multiplexer_pane_or_group_move("UP", "u"))
o.bind("SUPER + ALT + DOWN", "Focus Herdr/tmux pane down", multiplexer_pane_or_group_move("DOWN", "d"))
o.bind("SUPER + SHIFT + UP", "Next Herdr workspace or swap window up", function()
  if active_window_is_herdr_ghostty() then
    send_herdr_key("i")
  else
    hl.dispatch(hl.dsp.window.swap({ direction = "u" }))
  end
end)
o.bind("SUPER + SHIFT + DOWN", "Previous Herdr workspace or swap window down", function()
  if active_window_is_herdr_ghostty() then
    send_herdr_key("u")
  else
    hl.dispatch(hl.dsp.window.swap({ direction = "d" }))
  end
end)
