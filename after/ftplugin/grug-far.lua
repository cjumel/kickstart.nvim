-- [[ Keymaps ]]

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function toggle_hidden()
  local state = unpack(require("grug-far").toggle_flags({ "--hidden" }))
  vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
end
local function toggle_fixed_strings()
  local grug_far = require("grug-far")
  local state = unpack(grug_far.toggle_flags({ "--fixed-strings" }))
  vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
end
map("n", "<localleader>h", toggle_hidden, { desc = "Toggle --hidden flag" })
map("n", "<localleader>f", toggle_fixed_strings, { desc = "Toggle --fixed-strings flag" })
