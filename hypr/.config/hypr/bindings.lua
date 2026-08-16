-- Keep Omarchy's default SUPER bindings, except use Super+tilde for the root menu.
hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + GRAVE")
hl.unbind("SUPER + ALT + SPACE")
o.bind("SUPER + GRAVE", "Omarchy menu", "omarchy menu")
o.bind("ALT + GRAVE", "Apps menu", "omarchy-menu toggle apps")
