-- [[ Keymaps ]]

local keymap = require("config.keymap")

keymap.set_buffer("n", ";", "}", { desc = "Next hunk", remap = true })
keymap.set_buffer("n", ",", "{", { desc = "Previous hunk", remap = true })
