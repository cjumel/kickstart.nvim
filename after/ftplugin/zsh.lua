-- [[ Keymaps ]]

local actions = require("config.actions")
local keymap = require("config.keymap")

local bufname = vim.api.nvim_buf_get_name(0)
if vim.startswith(bufname, "/private/tmp/") then -- Temporary zsh scripts, like when editing a zsh command
  keymap.set_buffer("n", "q", actions.quit, { desc = "Quit" })
end
