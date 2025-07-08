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

--- Output the name of the Lua module corresponding to the current file.
---@return string
local function get_module()
  if vim.bo.filetype ~= "lua" then
    error("Not a Lua file")
  end
  local path = vim.fn.expand("%:.") -- File path relative to cwd
  -- Only keep the path part after "lua/" (useful for modules not in the cwd)
  local path_split = vim.fn.split(path, "lua/")
  if #path_split >= 2 then
    path = path_split[#path_split]
  elseif path:sub(1, 4) ~= "lua/" then -- File is not inside a "lua/" directory
    error("File is not a module")
  end
  -- Remove various prefixes and suffixes, and replace "/" by "."
  local module_ = path:gsub("^lua/", ""):gsub("%.lua$", ""):gsub(".init$", ""):gsub("/", ".")
  return module_
end

local function yank_module()
  local module = get_module()
  yank_with_notification(module)
end
local function yank_repl_command()
  local repl_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  yank_with_notification(repl_command)
end
vim.keymap.set("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Lua)", buffer = true })
vim.keymap.set("n", "<leader>yr", yank_repl_command, { desc = "[Y]ank: [R]EPL command (Lua)", buffer = true })
