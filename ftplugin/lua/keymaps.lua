vim.keymap.set("n", "<leader>ym", function()
  local path = (
    vim
      .fn
      .expand("%:.") -- Get the relative file path
      :gsub("^lua/", "") -- Remove the "lua/" prefix if it exists
      :gsub("^lua/", "") -- Remove the "lua/" prefix if it exists
      :gsub("%.lua$", "") -- Remove the ".lua" extension
      :gsub(".init$", "") -- Remove the ".init" suffix (in case in an init.lua file)
      :gsub("/", ".") -- Replace slashes with dots
  )
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end, { buffer = true, desc = "[Y]ank: [M]odule" })

vim.keymap.set("n", "<leader>yr", function()
  local run_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  vim.fn.setreg("+", run_command)
  vim.notify('Yanked "' .. run_command .. '" to clipboard') -- The clipboard is the default usecase
end, { buffer = true, desc = "[Y]ank: [R]un command (REPL)" })
