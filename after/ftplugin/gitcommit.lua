-- [[ Options ]]

-- Directly enter in insert mode
vim.api.nvim_win_set_cursor(0, { 1, 0 })
if vim.fn.getline(1) == "" then
  vim.cmd("startinsert!")
end

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

map("n", "q", actions.quit, { desc = "Quit" })
