-- [[ Keymaps ]]

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", ";", "}", { desc = "Next hunk", remap = true })
map("n", ",", "{", { desc = "Previous hunk", remap = true })
