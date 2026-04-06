-- [[ Keymaps ]]

local map = require("config.utils").map_buffer

local function yank_module()
  local lua_utils = require("config.lang_utils.lua")
  local register = vim.v.register
  local module = lua_utils.get_module()
  vim.fn.setreg(register, module)
  local message = "Yanked to register `" .. register .. "`:\n```\n" .. module .. "\n```"
  vim.notify(message, vim.log.levels.INFO, { title = "Yank" })
end
map("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Lua)" })
