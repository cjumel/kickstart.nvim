-- [[ Keymaps ]]

local map = require("config.utils").map_buffer

map("i", "<C-n>", function() require("dap.repl").on_down() end, { desc = "Next command" })
map("i", "<C-p>", function() require("dap.repl").on_up() end, { desc = "Previous command" })
