hl.config({
  input = {
    kb_layout = "pl,us",
    repeat_rate = 40,
    repeat_delay = 600,
    numlock_by_default = true,
    touchpad = {
      natural_scroll = false,
      scroll_factor = 0.4,
    },
  },
})

o.window("(Alacritty|kitty)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
