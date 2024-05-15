--- Yank the path of the current Lua module.
---@return nil
local function yank_module_path()
  local path = vim.fn.expand("%")
  path = vim.fn.fnamemodify(path, ":.")

  path = path:gsub("^lua/", "") -- Remove the "lua/" prefix if it exists
  path = path:gsub("%.lua$", "") -- Remove the ".lua" extension
  path = path:gsub(".init$", "") -- Remove the ".init" suffix (in case in an init.lua file)
  path = path:gsub("/", ".") -- Replace slashes with dots

  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end

vim.keymap.set("n", "<leader>ym", yank_module_path, { buffer = true, desc = "[Y]ank: current Lua [M]odule" })
