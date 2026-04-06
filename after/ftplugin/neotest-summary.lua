-- [[ Options ]]

vim.opt_local.wrap = false

-- [[ Keymaps ]]

local map = require("config.utils").map_buffer

map("n", "q", "<cmd>q<CR>", { desc = "Close" })
