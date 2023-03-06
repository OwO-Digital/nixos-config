terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
browser = "firefox"
mail = "mailspring"
files = "pcmanfm"
termfiles = "ranger"
music = "spotify"
emoji_picker = "emoji-picker"

editor_cmd = terminal .. " -e " .. editor
termfiles_cmd = terminal .. " -e " .. termfiles

laptop = false

scrkey = { mod = nil,   key = "Insert" }
--- I don't have Print Screen on my Desktop keyboard shut up >:(
