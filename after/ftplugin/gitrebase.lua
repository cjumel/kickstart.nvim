-- [[ Keymaps ]]

local actions = require("config.actions")
local keymap = require("config.keymap")

keymap.set_buffer("n", "q", actions.quit, { desc = "Quit" })
