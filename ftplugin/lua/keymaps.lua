--- Yank the path of the current Lua module.
---@return nil
local function yank_module()
  local path = vim.fn.expand("%:.") -- Relative file path

  path = path:gsub("^lua/", "") -- Remove the "lua/" prefix if it exists
  path = path:gsub("%.lua$", "") -- Remove the ".lua" extension
  path = path:gsub(".init$", "") -- Remove the ".init" suffix (in case in an init.lua file)
  path = path:gsub("/", ".") -- Replace slashes with dots

  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end
vim.keymap.set("n", "<localleader>y", yank_module, { buffer = true, desc = "[Y]ank module" })
