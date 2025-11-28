-- [[ Keymaps ]]

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function yank_module()
  local lua_utils = require("config.lang_utils.lua")
  local module = lua_utils.get_module()
  vim.fn.setreg('"', module)
  vim.notify('Yanked to register `"`:\n```\n' .. module .. "\n```", vim.log.levels.INFO, { title = "Yank" })
end
map("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Lua)" })
