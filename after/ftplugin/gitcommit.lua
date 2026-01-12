-- [[ Options ]]

-- Directly enter in insert mode
vim.api.nvim_win_set_cursor(0, { 1, 0 })
if vim.fn.getline(1) == "" then
  vim.cmd("startinsert!")
end
