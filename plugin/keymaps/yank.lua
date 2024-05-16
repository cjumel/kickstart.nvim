-- Keymaps to yank paths and similar objects, or to manipulate yanked text

--- Yank the path of the current buffer or directory if in Oil buffer.
---@param opts table|nil Optional parameters. Supported parameters are:
--- - cwd boolean: If true, yank the current working directory. Default is false.
--- - mods string: Modifications to apply to the path. Default is ":~:.".
---@return nil
local function yank_path(opts)
  opts = opts or {}
  local cwd = opts.cwd or false
  local mods = opts.mods or ":~:." -- Relative to cwd or home directory

  local path
  if cwd then
    path = vim.fn.getcwd()
  elseif vim.bo.filetype == "oil" then
    local oil = package.loaded.oil -- Oil should already have been loaded
    path = oil.get_current_dir()
  else
    path = vim.fn.expand("%")
  end

  path = vim.fn.fnamemodify(path, mods)
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end
vim.keymap.set("n", "<leader>yc", function() yank_path({ cwd = true, mods = ":~" }) end, { desc = "[Y]ank: [C]wd" })
vim.keymap.set("n", "<leader>yr", function() yank_path({ mods = ":~:." }) end, { desc = "[Y]ank: [R]elative path" })
vim.keymap.set("n", "<leader>ya", function() yank_path({ mods = ":~" }) end, { desc = "[Y]ank: [A]bsolute path" })

--- Send the content of the default register to the clipboard.
---@return nil
local function send_yanked_to_clipboard()
  local yank = vim.fn.getreg('"')
  vim.fn.setreg("+", yank)
  vim.notify('Sent "' .. yank .. '" to clipboard')
end
vim.keymap.set("n", "<leader>ys", send_yanked_to_clipboard, { desc = "[Y]ank: [S]end to clipboard" })
