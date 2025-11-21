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

local key_to_action = {
  p = "pick",
  r = "reword",
  e = "edit",
  s = "squash",
  f = "fixup",
  x = "exec",
  b = "break",
  d = "drop",
  l = "label",
  t = "reset",
  m = "merge",
  u = "update-ref",
}
for key, action in pairs(key_to_action) do
  map("n", "<localleader>" .. key, "^ce" .. action .. "<Esc>^j", { desc = 'Change keyword for "' .. action .. '"' })
end
