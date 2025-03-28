-- [[ Options ]]

-- Change the format options. These are adapted from Lua's default one in Neovim, defined in
-- `nvim/runtime/ftplugin/lua.vim` with `setlocal formatoptions-=t formatoptions+=croql`. Default formation options are:
-- "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

-- [[ Keymaps ]]

-- Python specific yanking keymaps
vim.keymap.set("n", "<localleader>ym", function()
  local module_ = require("lang_utils.python").get_module()
  vim.fn.setreg('"', module_)
  vim.notify('Yanked to register `"`:\n```\n' .. module_ .. "\n```")
end, { buffer = true, desc = "[Y]ank: [M]odule" })
vim.keymap.set("n", "<localleader>yi", function()
  local module_ = require("lang_utils.python").get_module()
  local import = "import " .. module_
  vim.fn.setreg('"', import, "l") -- Register linewise
  vim.notify('Yanked to register `"`:\n```\n' .. import .. "\n```")
end, { buffer = true, desc = "[Y]ank: [I]mport statement" })
vim.keymap.set("n", "<localleader>yf", function()
  local module_ = require("lang_utils.python").get_module()
  local from_import = "from " .. module_ .. " import "
  vim.fn.setreg('"', from_import, "l") -- Register linewise
  vim.notify('Yanked to register `"`:\n```\n' .. from_import .. "\n```")
end, { buffer = true, desc = "[Y]ank: [F]rom import statement" })
vim.keymap.set("n", "<localleader>yr", function()
  local run_command = [[exec(open("]] .. vim.fn.expand("%:p:.") .. [[").read())]]
  vim.fn.setreg("+", run_command)
  vim.notify("Yanked to register `+`:\n```\n" .. run_command .. "\n```")
end, { buffer = true, desc = "[Y]ank: [R]EPL run command" })

-- Python specific code actions
vim.keymap.set(
  "n",
  "<localleader>f",
  function() vim.lsp.buf.code_action({ context = { only = { "source.fixAll" } }, apply = true }) end,
  { desc = "[F]ix all fixable" }
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
end, { desc = "[I]mport" })

vim.keymap.set("n", "<localleader>a", function()
  local path = vim.fn.expand("%:.")
  local base_path
  if path:sub(1, 5) ~= "tests" then
    base_path = path:gsub("^src/", "")
    -- Remove the first directory as it may contain the package name, which is not found in the test file path
    local first_separator_idx = base_path:find("/")
    if first_separator_idx then
      base_path = base_path:sub(first_separator_idx + 1)
    end
    base_path = base_path:gsub(".py$", "")
  else
    base_path = path:gsub("^tests/", ""):gsub("^unit/", ""):gsub("^integration/", ""):gsub("_test.py$", "")
  end

  local candidate_files = {}
  local handle = io.popen("fd .")
  if handle then
    for file in handle:lines() do
      table.insert(candidate_files, file)
    end
    handle:close()
  end

  local alternate_files = {}
  for _, candidate_file in ipairs(candidate_files) do
    if candidate_file ~= path and candidate_file:find(base_path) then
      table.insert(alternate_files, candidate_file)
    end
  end
  if #alternate_files == 0 then
    vim.notify("No alternate files found")
  elseif #alternate_files == 1 then
    vim.cmd("edit " .. alternate_files[1])
  else
    vim.ui.select(alternate_files, {}, function(selection) vim.cmd("edit " .. selection) end)
  end
end, { desc = "[A]lternate files" })
