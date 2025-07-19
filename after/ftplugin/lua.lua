-- [[ Keymaps ]]

--- Yank the given item to the default register and notify the user.
---@param item string|nil
---@return nil
local function yank_with_notification(item)
  if item == nil then
    vim.notify("Nothing to yank", vim.log.levels.WARN, { title = "Yank (Lua)" })
    return
  end
  vim.fn.setreg('"', item)
  vim.notify('Yanked to register `"`:\n```\n' .. item .. "\n```", vim.log.levels.INFO, { title = "Yank (Lua)" })
end

local function yank_module()
  local lua_utils = require("config.lang_utils.lua")
  local module = lua_utils.get_module()
  yank_with_notification(module)
end
local function yank_repl_command()
  local repl_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  yank_with_notification(repl_command)
end
vim.keymap.set("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Lua)", buffer = true })
vim.keymap.set("n", "<leader>yr", yank_repl_command, { desc = "[Y]ank: [R]EPL command (Lua)", buffer = true })
