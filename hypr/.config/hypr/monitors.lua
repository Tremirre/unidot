local hostname_file = io.open("/etc/hostname", "r")
local hostname = hostname_file and hostname_file:read("*l") or ""

if hostname_file then
  hostname_file:close()
end

local profile = os.getenv("HOME") .. "/.config/hypr/monitors/" .. hostname .. ".lua"
local profile_file = io.open(profile, "r")

if profile_file then
  profile_file:close()
  dofile(profile)
else
  hl.env("GDK_SCALE", "2")
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
end
