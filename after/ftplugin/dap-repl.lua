-- [[ Keymaps ]]

local keymap = require("config.keymap")

keymap.set_buffer("i", "<C-n>", function() require("dap.repl").on_down() end, { desc = "Next command" })
keymap.set_buffer("i", "<C-p>", function() require("dap.repl").on_up() end, { desc = "Previous command" })
