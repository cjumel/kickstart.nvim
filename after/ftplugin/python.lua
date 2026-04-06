-- [[ Options ]]

-- Change the format options. These are adapted from Lua's default one in Neovim, defined in
-- `nvim/runtime/ftplugin/lua.vim` with `setlocal formatoptions-=t formatoptions+=croql`. Default formation options are:
-- "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

-- [[ Keymaps ]]

local map = require("config.utils").map_buffer

local function yank_module()
  local python_utils = require("config.lang_utils.python")
  local register = vim.v.register
  local module = python_utils.get_module()
  vim.fn.setreg(register, module)
  local message = "Yanked to register `" .. register .. "`:\n```\n" .. module .. "\n```"
  vim.notify(message, vim.log.levels.INFO, { title = "Yank" })
end
map("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Python)" })
