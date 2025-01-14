-- [[ Options ]]

-- Change the format options. These are adapted from Lua's default one in Neovim, defined in
--  `nvim/runtime/ftplugin/lua.vim` with `setlocal formatoptions-=t formatoptions+=croql`. Default formation options
--  are: "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

-- [[ Keymaps ]]

vim.keymap.set("n", "<leader>ym", function()
  local path = (
    vim
      .fn
      .expand("%:.") -- Get the relative file path
      :gsub("%.py$", "") -- Remove the ".py" extension
      :gsub(".__init__$", "") -- Remove the ".__init__" suffix (in case in an __init__.py file)
      :gsub("/", ".") -- Replace slashes with dots
  )
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end, { buffer = true, desc = "[Y]ank: [M]odule" })

vim.keymap.set("n", "<leader>yr", function()
  local run_command = [[exec(open("]] .. vim.fn.expand("%:p:.") .. [[").read())]]
  vim.fn.setreg("+", run_command)
  vim.notify('Yanked "' .. run_command .. '" to clipboard') -- The clipboard is the default usecase
end, { buffer = true, desc = "[Y]ank: [R]un command (REPL)" })
