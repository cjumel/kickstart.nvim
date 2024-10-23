--- Yank the path of the current Python module.
---@return nil
local function yank_module()
  local path = vim.fn.expand("%:.") -- Relative file path

  path = path:gsub("%.py$", "") -- Remove the ".py" extension
  path = path:gsub(".__init__$", "") -- Remove the ".__init__" suffix (in case in an __init__.py file)
  path = path:gsub("/", ".") -- Replace slashes with dots

  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end
vim.keymap.set("n", "<localleader>y", yank_module, { buffer = true, desc = "[Y]ank module" })
