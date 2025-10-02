-- [[ Keymaps ]]

local function yank_module()
  local lua_utils = require("config.lang_utils.lua")
  local module = lua_utils.get_module()
  vim.fn.setreg('"', module)
  vim.notify('Yanked to register `"`:\n```\n' .. module .. "\n```", vim.log.levels.INFO, { title = "Yank" })
end
local function yank_repl_command()
  local repl_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  vim.fn.setreg('"', repl_command)
  vim.notify('Yanked to register `"`:\n```\n' .. repl_command .. "\n```", vim.log.levels.INFO, { title = "Yank" })
end
vim.keymap.set("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Lua)", buffer = true })
vim.keymap.set("n", "<leader>yr", yank_repl_command, { desc = "[Y]ank: [R]EPL command (Lua)", buffer = true })
