-- [[ Options ]]

vim.opt_local.wrap = false

-- [[ Keymaps ]]

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "q", "<cmd>q<CR>", { desc = "Close" })
