-- [[ Options ]]

-- Change the format options. These are adapted from Lua's default one in Neovim, defined in
-- `nvim/runtime/ftplugin/lua.vim` with `setlocal formatoptions-=t formatoptions+=croql`. Default formation options are:
-- "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

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
  local module = require("config.lang_utils.python").get_module()
  vim.fn.setreg('"', module)
  vim.notify('Yanked to register `"`:\n```\n' .. module .. "\n```", vim.log.levels.INFO, { title = "Yank" })
end
local function yank_imports()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local import_lines = {}
  local imports_block_is_started = false

  for _, line in ipairs(lines) do
    if
      not imports_block_is_started and line:match("^%s*#") -- Comment line
    then
      table.insert(import_lines, line)
    elseif line:match("^import ") or line:match("^from ") then
      table.insert(import_lines, line)
      imports_block_is_started = true
    elseif
      imports_block_is_started
      and (
        line:match("^%s+") -- Indented line
        or line:match("^%)") -- Closing parenthesis
      )
    then
      table.insert(import_lines, line)
    elseif
      imports_block_is_started
      and (
        line:match("^%s*$") -- Empty line
        or line:match("^%s*#") -- Comment line
      )
    then
      table.insert(import_lines, line)
    elseif imports_block_is_started then
      break
    end
  end

  if #import_lines > 0 then
    local import_text = table.concat(import_lines, "\n")
    vim.fn.setreg('"', import_text)
    vim.notify(
      "Imports (" .. #import_lines .. ' lines) yanked to register `"`',
      vim.log.levels.INFO,
      { title = "Yank" }
    )
  else
    vim.notify("No imports found at the top of the file", vim.log.levels.WARN, { title = "Yank" })
  end
end
map("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Python)" })
map("n", "<leader>yi", yank_imports, { desc = "[Y]ank: [I]mports (Python)" })
