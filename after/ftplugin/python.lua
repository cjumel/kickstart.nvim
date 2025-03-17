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
  })
end, { desc = "[I]mport" })
