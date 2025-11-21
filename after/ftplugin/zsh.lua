-- [[ Keymaps ]]

local actions = require("config.actions")

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

local bufname = vim.api.nvim_buf_get_name(0)
if vim.startswith(bufname, "/private/tmp/") then -- Temporary zsh scripts, like when editing a zsh command
  map("n", "q", actions.quit, { desc = "Quit" })
end
