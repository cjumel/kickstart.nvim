local M = {}

M.laststatus = 3 -- Use a global status line & a thin line to separate splits

M.enable = function()
  vim.o.laststatus = M.laststatus
end

M.disable = function()
  vim.o.laststatus = 0
end

M.is_enabled = function()
  return vim.o.laststatus == M.laststatus
end

M.toggle = function()
  if M.is_enabled() then
    M.disable()
  else
    M.enable()
  end
end

return M
