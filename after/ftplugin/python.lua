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

local function auto_fix() vim.lsp.buf.code_action({ context = { only = { "source.fixAll" } }, apply = true }) end
local function auto_import()
  vim.lsp.buf.code_action({
    context = { only = { "quickfix" } },
    filter = function(input)
      return not not (string.find(input.title, "^import ") or string.find(input.title, "^from "))
    end,
    apply = true,
  })
end
local function pyright_ignore()
  vim.lsp.buf.code_action({
    context = { only = { "quickfix" } },
    filter = function(input) return not not string.find(input.title, "# pyright: ignore") end,
    apply = true,
  })
end
map("n", "<localleader>f", auto_fix, { desc = "Auto-[F]ix" })
map("n", "<localleader>i", auto_import, { desc = "Auto-[I]mport" })
map("n", "<localleader>p", pyright_ignore, { desc = "[P]yright ignore" })

---@param path string
---@return string|nil
local function get_base_path(path)
  if path:sub(1, 4) == "src/" then
    path = path:gsub("^src/", "")
    -- Remove the first directory as it usually is the package name (which is not found in the tests)
    local first_separator_idx = path:find("/")
    if first_separator_idx then
      path = path:sub(first_separator_idx + 1)
    end
    path = path:gsub(".py$", "")
  elseif path:sub(1, 6) == "tests/" then
    path = path:gsub("^tests/", ""):gsub("^unit/", ""):gsub("^integration/", ""):gsub("_test.py$", "")
  else
    return nil
  end
  -- Strip leading and trailing underscores from the filename (e.g. to match `_module.py` with `test_module.py`)
  path = path:gsub("([^/]+)$", function(filename) return filename:gsub("^_+", ""):gsub("_+$", "") end)
  return path
end
---@return string[]|nil
local function get_candidate_paths()
  local path = vim.fn.expand("%:.")
  local base_path = get_base_path(path)
  if not base_path then
    return
  end
  local candidate_paths = {}
  local handle = io.popen("fd --extension py .")
  if handle then
    for candidate_path in handle:lines() do
      candidate_path = vim.fn.fnamemodify(candidate_path, ":.")
      local candidate_base_path = get_base_path(candidate_path)
      if path ~= candidate_path and candidate_base_path == base_path then
        table.insert(candidate_paths, candidate_path)
      end
    end
    handle:close()
  end
  return candidate_paths
end
local function switch_to_alternate_file()
  local candidate_paths = get_candidate_paths()
  if not candidate_paths or #candidate_paths == 0 then
    vim.notify("No alternate file found", vim.log.levels.WARN, { title = "Alternate File" })
  elseif #candidate_paths == 1 then
    vim.cmd("edit " .. candidate_paths[1])
  else
    vim.ui.select(candidate_paths, {}, function(selected_path)
      if selected_path ~= nil then
        vim.cmd("edit " .. selected_path)
      end
    end)
  end
end
map("n", "<localleader>a", switch_to_alternate_file, { desc = "Switch to [A]lternate files" })
