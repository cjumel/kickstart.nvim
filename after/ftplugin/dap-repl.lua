-- [[ Keymaps ]]

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("i", "<C-n>", function() require("dap.repl").on_down() end, { desc = "Next command" })
map("i", "<C-p>", function() require("dap.repl").on_up() end, { desc = "Previous command" })
