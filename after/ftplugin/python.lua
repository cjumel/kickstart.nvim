-- [[ Options ]]

-- Change the format options. These are adapted from Lua's default one in Neovim, defined in
-- `nvim/runtime/ftplugin/lua.vim` with `setlocal formatoptions-=t formatoptions+=croql`. Default formation options are:
-- "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

-- [[ Keymaps ]]

vim.keymap.set("n", "<leader>ym", function()
  local module_ = require("lang_utils.python").get_module()
  vim.fn.setreg('"', module_)
  vim.notify('Yanked to register `"`:\n```\n' .. module_ .. "\n```")
end, { buffer = true, desc = "[Y]ank: [M]odule" })

vim.keymap.set("n", "<leader>yr", function()
  local run_command = [[exec(open("]] .. vim.fn.expand("%:p:.") .. [[").read())]]
  vim.fn.setreg("+", run_command)
  vim.notify("Yanked to register `+`:\n```\n" .. run_command .. "\n```")
end, { buffer = true, desc = "[Y]ank: REPL [R]un command" })
