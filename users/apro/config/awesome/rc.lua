--             _
--            | |
--  _ __ ___  | |_   _  __ _
-- | '__/ __| | | | | |/ _` |
-- | | | (__ _| | |_| | (_| |
-- |_|  \___(_)_|\__,_|\__,_|
-- This is the file that gets imported as the configuration at startup

-- Imports packages installed through LuaRocks if it is installed.
pcall(require, "luarocks.loader")

require("awful.autofocus") -- This thing's gonna get deprecated soon lmao
require("error_handling") -- Notify the user if there was an error

-- Initialize the theme
theme = "everblush"
require("themes")

require("conf")      -- Import configuration
require("ui")        -- Import widgets
require("signals")   -- Import signals
