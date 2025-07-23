-- [[ Options ]]

-- Change the format options. These are adapted from Lua's default one in Neovim, defined in
-- `nvim/runtime/ftplugin/lua.vim` with `setlocal formatoptions-=t formatoptions+=croql`. Default formation options are:
-- "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

-- [[ Keymaps ]]

local function yank_module()
  local module = require("config.lang_utils.python").get_module()
  vim.fn.setreg('"', module)
  vim.notify('Yanked to register `"`:\n```\n' .. module .. "\n```", vim.log.levels.INFO, { title = "Yank (Python)" })
end
local function yank_repl_command()
  local repl_command = [[exec(open("]] .. vim.fn.expand("%:p:.") .. [[").read())]]
  vim.fn.setreg('"', repl_command)
  vim.notify(
    'Yanked to register `"`:\n```\n' .. repl_command .. "\n```",
    vim.log.levels.INFO,
    { title = "Yank (Python)" }
  )
end
vim.keymap.set("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule (Python)", buffer = true })
vim.keymap.set("n", "<leader>yr", yank_repl_command, { desc = "[Y]ank: [R]EPL command (Python)", buffer = true })

vim.keymap.set(
  "n",
  "<localleader>f",
  function() vim.lsp.buf.code_action({ context = { only = { "source.fixAll" } }, apply = true }) end,
  { desc = "Auto-[F]ix" }
)
vim.keymap.set("n", "<localleader>i", function()
  vim.lsp.buf.code_action({
    context = { only = { "quickfix" } },
    filter = function(input)
      if string.find(input.title, "^import ") or string.find(input.title, "^from ") then
        return true
      end
      return false
    end,
    apply = true,
  })
end, { desc = "Auto-[I]mport" })

--- Output the base path of a path, that is the path striped of prefixes (like `src/<package-name>/` or `tests/`) and
--- suffixes (like `.py` or `_test.py`), or `nil` if there is none.
---@param path string The path to be converted.
---@return string|nil
local function get_base_path(path)
  path = vim.fn.fnamemodify(path, ":.")
  if path:sub(1, 4) == "src/" then
    path = path:gsub("^src/", "")
    -- Remove the first directory as it usually is the package name (which is not found in the tests)
    local first_separator_idx = path:find("/")
    if first_separator_idx then
      path = path:sub(first_separator_idx + 1)
    end
    path = path:gsub(".py$", "")
    return path
  elseif path:sub(1, 6) == "tests/" then
    path = path:gsub("^tests/", ""):gsub("^unit/", ""):gsub("^integration/", ""):gsub("_test.py$", "")
    return path
  else
    return nil
  end
end

vim.keymap.set("n", "<localleader>a", function()
  local path = vim.fn.expand("%:p")
  local base_path = get_base_path(path)
  if not base_path then
    vim.notify("No alternate file found")
    return
  end

  local candidate_paths = {}
  local handle = io.popen("fd --extension py .")
  if handle then
    for candidate_path in handle:lines() do
      candidate_path = vim.fn.fnamemodify(candidate_path, ":p")
      local candidate_base_path = get_base_path(candidate_path)
      if path ~= candidate_path and candidate_base_path == base_path then
        table.insert(candidate_paths, candidate_path)
      end
    end
    handle:close()
  end

  if #candidate_paths == 0 then
    vim.notify("No alternate file found")
  elseif #candidate_paths == 1 then
    vim.cmd("edit " .. candidate_paths[1])
  else
    vim.ui.select(candidate_paths, {}, function(selected_path)
      if selected_path ~= nil then
        vim.cmd("edit " .. selected_path)
      end
    end)
  end
end, { desc = "Switch to [A]lternate files" })
