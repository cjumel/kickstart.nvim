-- [[ Keymaps ]]

vim.keymap.set("n", "<leader>ym", function()
  local path = vim.fn.expand("%:.") -- File path relative to cwd
  -- Only keep the path part after "lua/"
  local path_split = vim.fn.split(path, "lua/")
  if #path_split >= 2 then
    path = path_split[#path_split]
  elseif path:sub(1, 4) ~= "lua/" then -- File is not inside a "lua/" directory
    error("File is not a module")
  end
  -- Remove various prefixes and suffixes, and replace "/" by "."
  path = path:gsub("^lua/", "")
  path = path:gsub("%.lua$", "")
  path = path:gsub(".init$", "")
  path = path:gsub("/", ".")
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end, { buffer = true, desc = "[Y]ank: [M]odule" })

vim.keymap.set("n", "<leader>yr", function()
  local run_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  vim.fn.setreg("+", run_command)
  vim.notify('Yanked "' .. run_command .. '" to clipboard') -- The clipboard is the default usecase
end, { buffer = true, desc = "[Y]ank: [R]un command (REPL)" })
